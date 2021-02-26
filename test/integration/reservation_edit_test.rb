require 'test_helper'

class ReservationEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @reservation = reservations(:one)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_reservation_path(@reservation)
    assert_template 'reservations/edit'
    patch reservation_path(@reservation), params: { reservation: {
      start_date: "",
      end_date: "",
      number_of_people: "",
    } }
    assert_template 'reservations/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_reservation_path(@reservation)
    log_in_as(@user)
    assert_redirected_to edit_reservation_path(@reservation)
    follow_redirect!
    start_date = Faker::Date.between(from: '2020-11-23', to: '2020-11-30')
    end_date = Faker::Date.between(from: '2020-12-01', to: '2020-12-10')
    number_of_people = Faker::Number.between(from: 1, to: 5)
    patch reservation_path(@reservation), params: { reservation: {
      start_date: start_date,
      end_date: end_date,
      number_of_people: number_of_people,
    } }
    assert_not flash.empty?
    assert_redirected_to reservations_path
    follow_redirect!
    @reservation.reload
    assert_equal start_date, @reservation.start_date
    assert_equal end_date, @reservation.end_date
    assert_equal number_of_people, @reservation.number_of_people
  end
end
