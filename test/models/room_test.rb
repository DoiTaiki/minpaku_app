require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @room = @user.rooms.build(name: "A city's seaside",
                              room_introduction: "beautiful seaside",
                              price: 2000,
                              address: "A city 1-1-1",
                              image: { io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg' })
  end

  test "should be valid" do
    assert @room.valid?
  end

  test "user id should be present" do
    @room.user_id = nil
    assert_not @room.valid?
  end

  test "name should be present" do
    @room.name = nil
    assert_not @room.valid?
  end

  test "name should be at most 50 characters" do
    @room.name = "a" * 51
    assert_not @room.valid?
  end

  test "room_introduction should be present" do
    @room.room_introduction = nil
    assert_not @room.valid?
  end

  test "room_introduction should be at most 255 characters" do
    @room.room_introduction = "a" * 256
    assert_not @room.valid?
  end

  test "price should be present" do
    @room.price = nil
    assert_not @room.valid?
  end

  test "price should be at most 50 characters" do
    @room.price = ("1" * 51).to_i
    assert_not @room.valid?
  end

  test "address should be present" do
    @room.address = nil
    assert_not @room.valid?
  end

  test "address should be at most 50 characters" do
    @room.address = "a" * 256
    assert_not @room.valid?
  end

  test "address should be unique" do
    duplicate_room = @room.dup
    @room.save
    assert_not duplicate_room.valid?
  end

  test "image should be present" do
    @room.image = nil
    assert_not @room.valid?
  end

  test "order should be most recent first" do
    assert_equal rooms(:most_recent), Room.first
  end

  test "associated reservations should be destroyed" do
    @room.save
    @room.reservations.create!(start_date: Faker::Date.between(from: '2020-11-23', to: '2020-11-30'),
                               end_date: Faker::Date.between(from: '2020-12-01', to: '2020-12-10'),
                               number_of_people: 2,
                               user_id: @other_user.id)
    assert_difference 'Reservation.count', -1 do
      @other_user.destroy
    end
  end
end
