require 'test_helper'
require 'date'

class ReservationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @room = rooms(:one)
    @reservation = @room.reservations.build(start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30'),
                                            end_date: Faker::Date.between(from: '2020-12-01', to: '2020-12-10'),
                                            number_of_people: 2,
                                            user_id: @user.id)
  end

  test "should be valid" do
    assert @reservation.valid?
  end

  test "start_date should be present" do
    @reservation.start_date = nil
    assert_not @reservation.valid?
  end

  test "end_date should be present" do
    @reservation.end_date = nil
    assert_not @reservation.valid?
  end

  test "number_of_people should be present" do
    @reservation.number_of_people = nil
    assert_not @reservation.valid?
  end

  test "user_id should be present" do
    @reservation.user_id = nil
    assert_not @reservation.valid?
  end

  test "room_id should be present" do
    @reservation.room_id = nil
    assert_not @reservation.valid?
  end

  test "order should be most recent first" do
    assert_equal reservations(:most_recent), Reservation.first
  end
end
