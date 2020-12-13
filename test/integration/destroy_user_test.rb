require 'test_helper'

class DestroyUserTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "should not allow the admin attribute to be edited via a web" do
    log_in_as(@non_admin)
    assert_not @non_admin.admin?
    patch user_path, params: { user: { password:              "password",
                                       password_confirmation: "password",
                                       admin: true  } }
    assert_not @non_admin.reload.admin?
  end
  
  test "should switch layout when logged in as admin or non-admin" do
    log_in_as(@admin)
    get root_path
    assert_select 'a[href=?]', user_path, method: :delete, text: "アカウントの削除", count: 0
    assert_select 'a[href=?]', all_users_user_path, text: "全てのユーザー"
    log_in_as(@non_admin)
    get root_path
    assert_select 'a[href=?]', user_path, method: :delete, text: "アカウントの削除"
    assert_select 'a[href=?]', all_users_user_path, text: "全てのユーザー", count: 0
  end
  
  test "all_users including pagination and delete links" do
    log_in_as(@admin)
    get all_users_user_path
    assert_template 'users/all_users'
    assert_select 'div.pagination'
    first_pages_of_users = User.paginate(page: 1)
    first_pages_of_users.each do |user|
      unless user == @admin
        assert_select 'a[href=?]', "/user/#{user.id}/destroy_by_admin", text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete "/user/#{@non_admin.id}/destroy_by_admin"
    end
  end
  
  test "destroy my account by non-admin" do
    log_in_as(@non_admin)
    assert_difference 'User.count', -1 do
      delete user_path
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end
  
  test "should redirect destroy and destroy_by_admin when admin destroy himself or herself" do
    log_in_as(@admin)
    assert_no_difference 'User.count' do
      delete "/user/#{@admin.id}/destroy_by_admin"
    end
    assert_not flash.empty?
    assert_redirected_to all_users_user_path
    assert_no_difference 'User.count' do
      delete user_path
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end
end
