class RoomsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :posts]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:index, :destroy_by_admin]

  def index
    @rooms = Room.paginate(page: params[:page])
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    @room.image.attach(params[:room][:image])
    if @room.save
      flash[:success] = "部屋が登録されました！"
      redirect_to posts_rooms_path
    else
      render 'new'
    end
  end

  def show
    @room = Room.find_by(id: params[:id])
    @user = User.find_by(id: @room.user_id)
    @reservation = @room.reservations.build
  end

  def edit
    @room = Room.find_by(id: params[:id])
  end

  def update
    @room = Room.find_by(id: params[:id])
    if @room.update(room_params)
      flash[:success] = "編集内容が保存されました！"
      redirect_to posts_rooms_path
    else
      render 'edit'
    end
  end

  def destroy
    @room = Room.find_by(id: params[:id])
    @room.destroy
    flash[:success] = "部屋情報が削除されました"
    redirect_to posts_rooms_path
  end

  def posts
    @user = current_user
    @rooms = @user.rooms.paginate(page: params[:page])
  end

  def search
    column = params[:column]
    keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    negative_keywords, positive_keywords =
      keywords.partition { |keyword| keyword.start_with?("-") }

    @searched_rooms = Room.none

    positive_keywords.each do |keyword|
      @searched_rooms = @searched_rooms.or(Room.search(keyword, column))
    end

    negative_keywords.each do |keyword|
      @searched_rooms = @searched_rooms.minus_search(keyword, column)
    end

    @strict_searched_rooms = @searched_rooms

    positive_keywords.each do |keyword|
      @strict_searched_rooms.nil? ? break : @strict_searched_rooms = @strict_searched_rooms.search(keyword, column)
    end

    if !@strict_searched_rooms.nil?
      strict_searched_room_ids = []
      @strict_searched_rooms.each do |strict_searched_room|
        strict_searched_room_ids.push(strict_searched_room.id)
      end
      @searched_rooms = @searched_rooms.where.not(id: strict_searched_room_ids)
    end
  end

  def destroy_by_admin
    @room = Room.find_by(id: params[:id])
    @room.destroy
    flash[:success] = "部屋情報が削除されました"
    redirect_to rooms_path
  end

  private

  def room_params
    params.require(:room).permit(:name, :room_introduction, :price, :address, :image)
  end

  def correct_user
    @room = Room.find(params[:id])
    @user = User.find(@room.user_id)
    redirect_to root_url unless current_user?(@user)
  end
end
