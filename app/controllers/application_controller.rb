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

end
