require 'test_helper'

class RoomsEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @room = rooms(:one)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_room_path(@room)
    assert_template 'rooms/edit'
    patch room_path(@room), params: { room: {
      name: "",
      room_introduction: "",
      price: "",
      address: "",
    } }
    assert_template 'rooms/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_room_path(@room)
    log_in_as(@user)
    assert_redirected_to edit_room_path(@room)
    follow_redirect!
    name = "Foo Bar"
    room_introduction = "Foo bar buzz"
    price = 5000
    address = Faker::Lorem.unique.sentence(word_count: 1) + "_city"
    patch room_path(@room), params: { room: {
      name: name,
      room_introduction: room_introduction,
      price: price,
      address: address,
    } }
    assert_not flash.empty?
    assert_redirected_to posts_rooms_path
    follow_redirect!
    @room.reload
    assert_equal name, @room.name
    assert_equal room_introduction, @room.room_introduction
    assert_equal price, @room.price
    assert_equal address, @room.address
  end
end
