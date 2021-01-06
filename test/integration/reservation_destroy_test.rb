require 'test_helper'

class ReservationDestroyTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @reservation = reservations(:one)
  end

  test "destroy my reservation" do
    log_in_as(@user)
    assert_difference 'Reservation.count', -1 do
      delete reservation_path(@reservation)
    end
    assert_not flash.empty?
    assert_redirected_to reservations_path
  end
end
