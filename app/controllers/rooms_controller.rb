class RoomsController < ApplicationController
    before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :posts]

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      flash[:success] = "部屋が登録されました！"
      redirect_to room_path(@room)
    else
      render 'rooms/new'
    end
  end

  def show
    @room = Room.find_by(id: params[:id])
    @user = User.find_by(id: @room.user_id)
    #@reservation
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def posts
    @rooms = current_user.rooms.paginate(page: params[:page])
  end
  
  def search
    column = params[:column]
    keywords = params[:keyword].split(/[[:blank:]]+/).select(&:present?)
    negative_keywords, positive_keywords = 
      keywords.partition {|keyword| keyword.start_with?("-") }
    
    @searched_rooms = Room.none
    
    positive_keywords.each do |keyword|
      @searched_rooms = @searched_rooms.or(Room.search(keyword, column))
    end
    
    #@searched_rooms = Room.search(keywords, column)
    
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
  
  private
    def room_params
      params.require(:room).permit(:name, :room_introduction, :price, :address, :image)
    end
end
