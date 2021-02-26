require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path
    assert_template 'users/edit'
    patch user_path, params: { user: {
      name: "",
      email: "foo@invalid",
      password: "foo",
      password_confirmation: "bar",
    } }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path
    log_in_as(@user)
    assert_redirected_to edit_user_path
    follow_redirect!
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path, params: { user: {
      name: name,
      email: email,
      password: "",
      password_confirmation: "",
    } }
    assert_not flash.empty?
    assert_redirected_to user_account_path
    follow_redirect!
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "unsuccessful profile update" do
    log_in_as(@user)
    get profile_user_path
    assert_template 'users/profile'
    patch profile_user_path, params: { user: { self_introduction: "a" * 256 } }
    assert_template 'users/profile'
  end

  test "successful profile update with friendly forwarding" do
    get profile_user_path
    log_in_as(@user)
    assert_redirected_to profile_user_path
    follow_redirect!
    self_introduction = @user.self_introduction
    patch profile_user_path, params: { user: { self_introduction: self_introduction } }
    assert_not flash.empty?
    assert_redirected_to profile_user_path
    follow_redirect!
    @user.reload
    assert_equal self_introduction, @user.self_introduction
  end
end
