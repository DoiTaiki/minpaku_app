require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get users_sign_up" do
    get user_sign_up_path
    assert_response :success
  end
  
  test "should redirect all_users_user_path when not logged in" do
    get all_users_user_path
    assert_redirected_to sign_in_user_path
  end
  
  test "should get users_account" do
    log_in_as(@user)
    get user_account_path
    assert_response :success
  end
  
  test "should get sign_in" do
    get sign_in_user_path
    assert_response :success
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect update when not logged in" do
    patch user_url, params: { user: { name: @user.name,
                                      email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect profile when not logged in" do
    get profile_user_path
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect profile_update when not logged in" do
    patch profile_user_path, params: { user: { self_introduction: @user.self_introduction } }
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end

  
    test "should not allow to get all_users when logged in as non-admin" do
    log_in_as(@other_user)
    get root_path
    get all_users_user_path
    assert_not flash.empty?
    assert_redirected_to root_path
  end
  
  test "should redirect destroy_by_admin when not logged in" do
    assert_no_difference 'User.count' do
      delete "/user/#{@user.id}/destroy_by_admin"
    end
    assert_not flash.empty?
    assert_redirected_to sign_in_user_path
  end
  
  test "should redirect destroy_by_admin when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete "/user/#{@user.id}/destroy_by_admin"
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
