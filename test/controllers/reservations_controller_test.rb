require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = @admin = users(:michael)
    @other_user = @non_admin = users(:archer)
    @reservation = reservations(:one)
    @other_room = reservations(:two)
  end

  test "should get index" do
    log_in_as(@user)
    get reservations_path
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_reservation_path(@reservation)
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get reservations_path
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Reservation.count' do
      post reservations_path, params: { reservation: {
        start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30'),
        end_date: Faker::Date.between(from: '2020-12-01', to: '2020-12-10'),
        number_of_people: 5,
      } }
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect edit when not logged in" do
    get edit_reservation_path(@reservation)
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect update when not logged in" do
    assert_no_difference 'Reservation.count' do
      patch reservation_path(@reservation), params: { reservation: {
        start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30'),
        end_date: Faker::Date.between(from: '2020-12-01', to: '2020-12-10'),
        number_of_people: 5,
      } }
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Room.count' do
      delete reservation_path(@reservation)
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_reservation_path(@reservation)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch reservation_path(@reservation), params: { reservation: { start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30') } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    delete reservation_path(@reservation)
    assert flash.empty?
    assert_redirected_to root_path
  end
end
