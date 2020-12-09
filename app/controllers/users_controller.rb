class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "登録完了しました！"
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  def sign_in
  end
  
  def session_create
  end
  
  def profile
  end
  
  def logout
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                    :password_confirmation)
    end
end
