require 'test_helper'

class ReservationsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    31.times do |n|
      @reservation = @user.reservations.create!(start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30'),
                                                end_date: Faker::Date.between(from: '2020-12-01', to: '2020-12-10'),
                                                number_of_people: Faker::Number.between(from: 1, to: 5),
                                                room_id: rooms(:one).id)
    end
  end

  test "reservations display" do
    log_in_as(@user)
    get reservations_path
    assert_template 'reservations/index'
    assert_match @user.reservations.count.to_s, response.body
    assert_not_equal 0, @user.reservations.count
    assert_select 'div.pagination', count: 2
    @user.reservations.paginate(page: 1).each do |reservation|
      room = Room.find_by(id: reservation.room_id)
      assert_select "a[href=?]", room_path(room), count: 60
      assert_select "a[href=?]", edit_reservation_path(reservation)
      assert_select "a[href=?]", reservation_path(reservation), method: :delete
      assert room.image.attached?
      assert_match room.name, response.body
      assert_match room.room_introduction, response.body
      total_price = (reservation.end_date - reservation.start_date) / (60 * 60 * 24) * reservation.number_of_people * room.price
      assert_match total_price.to_i.to_s, response.body
      assert_match reservation.start_date.to_s, response.body
      assert_match reservation.end_date.to_s, response.body
      assert_match reservation.created_at.to_s, response.body
      assert_match "変更", response.body
      assert_match "取り消し", response.body
    end
  end
end
