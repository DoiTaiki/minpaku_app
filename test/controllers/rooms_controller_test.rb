require 'test_helper'

class RoomsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael) 
  end

  test "should get rooms/posts" do
    log_in_as(@user)
    get posts_rooms_path
    assert_response :success
  end

  test "should get new" do
    get new_room_path
    assert_response :success
  end

  test "should get show" do
    get room_path(:id)
    assert_response :success
  end

  test "should get edit" do
    get edit_room_path(:id)
    assert_response :success
  end
end
