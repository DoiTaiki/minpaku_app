require 'test_helper'

class ReservationCreateTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @room = rooms(:one)
  end

  test "unsuccessful create reservation" do
    log_in_as(@user)
    get room_path(@room)
    assert_template 'rooms/show'
    assert_no_difference 'Reservation.count' do
      post reservations_path, params: { reservation: {
        start_date: "",
        end_date: "",
        number_of_people: "",
        room_id: @room.id,
      } }
    end
    assert_template 'rooms/show'
  end

  test "successful create reservation" do
    log_in_as(@user)
    get room_path(@room)
    assert_template 'rooms/show'
    start_date = Faker::Date.between(from: '2020-11-23', to: '2020-11-30')
    end_date = Faker::Date.between(from: '2020-12-01', to: '2020-12-10')
    number_of_people = Faker::Number.between(from: 1, to: 5)
    assert_difference 'Reservation.count', 1 do
      post reservations_path, params: { reservation: {
        start_date: start_date,
        end_date: end_date,
        number_of_people: number_of_people,
        room_id: @room.id,
      } }
    end
    assert_not flash.empty?
    assert_redirected_to reservations_path
  end
end
