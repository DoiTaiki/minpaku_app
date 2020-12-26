require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:michael)
    @user = @non_admin = users(:archer)
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
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", sign_in_user_path, count: 0
    assert_select "a[href=?]", user_sign_up_path, count: 0
    assert_select "a[href=?]", search_rooms_path(keyword: "東京", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "大阪", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "京都", column: "address")
    assert_select "a[href=?]", search_rooms_path(keyword: "札幌", column: "address")
  end
  
  test "should switch layout when logged in as admin or non-admin" do
    log_in_as(@admin)
    get root_path
    assert_select 'a[href=?]', user_path, method: :delete, text: "アカウントの削除", count: 0
    assert_select 'a[href=?]', all_users_user_path, text: "全てのユーザー"
    assert_select 'a[href=?]', rooms_path, text: "全てのルーム"
    log_in_as(@non_admin)
    get root_path
    assert_select 'a[href=?]', user_path, method: :delete, text: "アカウントの削除"
    assert_select 'a[href=?]', all_users_user_path, text: "全てのユーザー", count: 0
    assert_select 'a[href=?]', rooms_path, text: "全てのルーム", count: 0
  end
end
