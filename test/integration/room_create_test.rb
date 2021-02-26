require 'test_helper'

class RoomCreateTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "unsuccessful create room" do
    log_in_as(@user)
    get new_room_path
    assert_template 'rooms/new'
    assert_no_difference 'Room.count' do
      image = fixture_file_upload('./test/fixtures/files/images/lake-192990_640.jpg', 'image/jpeg')
      post rooms_path, params: { room: {
        name: "",
        room_introduction: "",
        price: 1,
        address: "",
        image: image,
      } }
    end
    assert_template 'rooms/new'
  end

  test "successful create room" do
    log_in_as(@user)
    get new_room_path
    assert_template 'rooms/new'
    name = "Foo Bar"
    room_introduction = "Foo bar buzz"
    price = 5000
    address = Faker::Lorem.unique.sentence(word_count: 1) + "_city"
    image = fixture_file_upload('./test/fixtures/files/images/lake-192990_640.jpg', 'image/jpeg')
    assert_difference 'Room.count', 1 do
      post rooms_path, params: { room: {
        name: name,
        room_introduction: room_introduction,
        price: price,
        address: address,
        image: image,
      } }
    end
    assert_not flash.empty?
    assert assigns(:room).image.attached?
    assert_redirected_to posts_rooms_path
  end
end
