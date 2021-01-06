require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get user_sign_up_path
    assert_no_difference 'User.count' do
      post user_path, params: { user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar",
      } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    get user_sign_up_path
    assert_difference 'User.count', 1 do
      post user_path, params: { user: {
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password",
      } }
    end
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
