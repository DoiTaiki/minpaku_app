class ReservationsController < ApplicationController
    before_action :logged_in_user, only: [:index, :create, :edit, :update, :destroy]
    before_action :correct_user, only: [:edit, :update, :destroy]
  
  def index
    @reservations = current_user.reservations.paginate(page: params[:page])
  end
  
  def create
    @user = User.find_by(id: current_user.id)
    @room = Room.find_by(id: params[:reservation][:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    if @reservation.save
      flash[:success] = "予約内容が登録されました！"
      redirect_to reservations_path
    else
      render 'rooms/show'
    end
  end
  
  def edit
    @reservation = Reservation.find_by(id: params[:id])
  end
  
  def update
    @reservation = Reservation.find_by(id: params[:id])
    if @reservation.update(reservation_params)
      flash[:success] = "編集内容が保存されました！"
      redirect_to reservations_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @reservation = Reservation.find_by(id: params[:id])
    @reservation.destroy
    flash[:success] = "予約が取り消されました"
    redirect_to reservations_path
  end
  
  private
    
    def reservation_params
      params.require(:reservation).permit(:start_date, :end_date, :number_of_people, :user_id, :room_id)
    end
    
    def correct_user
      @reservation = Reservation.find(params[:id])
      @user = User.find(@reservation.user_id)
      redirect_to root_url unless current_user?(@user)
    end
end
