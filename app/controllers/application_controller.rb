class ApplicationController < ActionController::Base
  include UsersHelper
  
  private
  
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインして下さい"
        redirect_to sign_in_user_path
      end
    end
    
    def admin_user
      if !current_user.admin?
        flash[:danger] = "管理者以外実行できません"
        redirect_to root_path
      end
    end
end
