require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = @admin = users(:michael)
    @other_user = @non_admin = users(:archer)
    @room = @user.rooms.create!(name: Faker::Lorem.sentence(word_count: 1),
                                room_introduction: Faker::Lorem.sentence(word_count: 1),
                                price: 1000,
                                address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
                                image: { io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg' })
    @other_room = rooms(:other_users_room)
  end

  test "should get index" do
    log_in_as(@admin)
    get rooms_path
    assert_response :success
  end

  test "should get new" do
    log_in_as(@user)
    get new_room_path
    assert_response :success
  end

  test "should get show" do
    log_in_as(@user)
    get room_path(@room)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_room_path(@room)
    assert_response :success
  end

  test "should get posts" do
    log_in_as(@user)
    get posts_rooms_path
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get new_room_path
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Room.count' do
      post rooms_path, params: { room: {
        name: Faker::Lorem.sentence(word_count: 1),
        room_introduction: Faker::Lorem.sentence(word_count: 1),
        price: 1000,
        address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
        image: { io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg' },
      } }
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect edit when not logged in" do
    get edit_room_path(@room)
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect update when not logged in" do
    assert_no_difference 'Room.count' do
      patch room_path(@room), params: { room: {
        name: "update",
        room_introduction: "upadate",
        price: 2000,
        address: Faker::Lorem.unique.sentence(word_count: 1) + "city",
        image: { io: File.open('./test/fixtures/files/images/lake-192990_640.jpg'), filename: 'lake-192990_640.jpg' },
      } }
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Room.count' do
      delete room_path(@room)
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect posts when not logged in" do
    get posts_rooms_path
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_room_path(@room)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch room_path(@room), params: { room: {
      name: @room.name,
      room_introduction: @room.room_introduction,
    } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect destroy when logged in as wrong user" do
    log_in_as(@other_user)
    delete room_path(@room)
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect index when logged in ad non admin user" do
    log_in_as(@non_admin)
    get rooms_path
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect destroy_by_admin when logged in ad non admin user" do
    log_in_as(@non_admin)
    delete destroy_by_admin_room_path(@room)
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
