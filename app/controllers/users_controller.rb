class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
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
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'sign_in'
    end
  end
  
  def profile
  end
  
  def logout
    log_out if logged_in?
    redirect_to root_path
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, 
                                    :password_confirmation)
    end
end
