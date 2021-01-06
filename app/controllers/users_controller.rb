class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy, :profile, :profile_update, :all_users, :destroy_by_admin]
  before_action :admin_user, only: [:all_users, :destroy_by_admin]
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
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:success] = "編集内容が保存されました！"
      redirect_to user_account_path
    else
      render 'edit'
    end
  end

  def destroy
    if !current_user.admin?
      current_user.destroy
      flash[:success] = "アカウントが削除されました"
      redirect_to root_path
    else
      flash[:danger] = "管理者は削除できません"
      redirect_to root_path
    end
  end

  def profile
    @user = current_user
  end

  def profile_update
    @user = current_user
    if @user.update(params.require(:user).permit(:self_introduction))
      flash[:success] = "編集内容が保存されました！"
      redirect_to profile_user_path
    else
      render 'profile'
    end
  end

  def sign_in
  end

  def session_create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'sign_in'
    end
  end

  def logout
    log_out if logged_in?
    redirect_to root_path
  end

  def all_users
    @users = User.paginate(page: params[:page])
  end

  def destroy_by_admin
    @user = User.find_by(id: params[:id])
    if !@user.admin?
      @user.destroy
      flash[:success] = "選択したユーザーを削除しました"
      redirect_to all_users_user_path
    else
      flash[:danger] = "管理者自身は削除できません"
      redirect_to all_users_user_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
