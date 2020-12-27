require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end
  
  test "login with invalid information" do
    get sign_in_user_path
    assert_template 'users/sign_in'
    post sign_in_user_path, params: { session: { email: "", password: "" } }
    assert_template 'users/sign_in'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with valid information followed by logout" do
    get sign_in_user_path
    assert_template 'users/sign_in'
    post sign_in_user_path, params: { session: { email: @user.email,
                                                 password: 'password' } }
    assert is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_select "a[href=?]", sign_in_user_path, count: 0
    assert_select "a[href=?]", user_sign_up_path, count: 0
    assert_select "a[href=?]", new_room_path
    assert_select "a[href=?]", reservations_path
    assert_select "a[href=?]", posts_rooms_path
    assert_select "a[href=?]", user_account_path
    assert_select "a[href=?]", logout_user_path
    delete logout_user_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    delete logout_user_path
    follow_redirect!
    assert_select "a[href=?]", sign_in_user_path
    assert_select "a[href=?]", user_sign_up_path
    assert_select "a[href=?]", new_room_path, count: 0
    assert_select "a[href=?]", reservations_path, count: 0
    assert_select "a[href=?]", posts_rooms_path, count:0
    assert_select "a[href=?]", user_account_path, count: 0
    assert_select "a[href=?]", logout_user_path, count: 0
  end
  
  test "login with valid email/invalid password" do
    get sign_in_user_path
    assert_template 'users/sign_in'
    post sign_in_user_path, params: { session: { email: @user.email, 
                                                 password: "invalid" } }
    assert_not is_logged_in?
    assert_template 'users/sign_in'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with invalid email/valid password" do
    get sign_in_user_path
    assert_template 'users/sign_in'
    post sign_in_user_path, params: { session: { email: "invalid", 
                                                 password: "password" } }
    assert_template 'users/sign_in'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
    assert_not_nil assigns(:user).remember_digest
    assert_not_equal cookies[:remember_token], assigns(:user).remember_digest
  end
  
  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    delete logout_user_path
    log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
    assert_nil assigns(:user).remember_digest
  end
end
