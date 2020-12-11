require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get users_sign_up" do
    get user_sign_up_path
    assert_response :success
  end
  
  #test "should get users_account" do
    #get user_account_path
    #assert_response :success
  #end
  
  test "should get sign_in" do
    get sign_in_user_path
    assert_response :success
  end

end
