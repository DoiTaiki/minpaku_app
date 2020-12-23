require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "layouts links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", sign_in_user_path
    assert_select "a[href=?]", user_sign_up_path
    assert_select "a[href=?]", search_rooms_path(keyword: "東京", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "大阪", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "京都", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "札幌", column: "address")
    assert_select "a[href=?]", all_users_user_path, count: 0
    log_in_as(@admin)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", sign_in_user_path, count: 0
    assert_select "a[href=?]", user_sign_up_path, count: 0
    assert_select "a[href=?]", search_rooms_path(keyword: "東京", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "大阪", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "京都", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "札幌", column: "address")
    assert_select "a[href=?]", all_users_user_path
    delete logout_user_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    log_in_as(@non_admin)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", sign_in_user_path, count: 0
    assert_select "a[href=?]", user_sign_up_path, count: 0
    assert_select "a[href=?]", search_rooms_path(keyword: "東京", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "大阪", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "京都", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "札幌", column: "address")
    assert_select "a[href=?]", all_users_user_path, count: 0
  end
end
