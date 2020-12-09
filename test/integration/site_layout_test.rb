require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "layouts links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", new_room_path
    assert_select "a[href=?]", reservations_path
    assert_select "a[href=?]", rooms_path
    assert_select "a[href=?]", account_user_path
    assert_select "a[href=?]", logout_user_path
    assert_select "a[href=?]", "/rooms/search?area=東京"
    assert_select "a[href=?]", "/rooms/search?area=大阪"
    assert_select "a[href=?]", "/rooms/search?area=京都"
    assert_select "a[href=?]", "/rooms/search?area=札幌"
  end
end
