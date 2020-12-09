require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get users_sign_up" do
    get users_sign_up_path
    assert_response :success
  end
  
  test "should get users_account" do
    get users_account_path
    assert_response :success
  end

end
