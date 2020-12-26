require 'test_helper'

class RoomsDestroyTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @room = rooms(:one)
    @other_room = rooms(:other_users_room)
  end
  
  test "destroy my room by admin and non-admin" do
    log_in_as(@admin)
    assert_difference 'Room.count', -1 do
      delete room_path(@room)
    end
    assert_not flash.empty?
    assert_redirected_to posts_rooms_path
    log_in_as(@non_admin)
    assert_difference 'Room.count', -1 do
      delete room_path(@other_room)
    end
    assert_not flash.empty?
    assert_redirected_to posts_rooms_path
  end

  test "destroy_by_admin room by not non-admin but admin" do
    log_in_as(@admin)
    assert_difference 'Room.count', -1 do
      delete destroy_by_admin_room_path(@other_room)
    end
    assert_not flash.empty?
    assert_redirected_to rooms_path
    log_in_as(@non_admin)
    assert_no_difference 'Room.count' do
      delete destroy_by_admin_room_path(@other_room)
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
