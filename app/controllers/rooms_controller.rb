class RoomsController < ApplicationController

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def delete
  end

  def posts
    @user = User.find(current_user.id)
    @rooms = @user.rooms.paginate(page: params[:page])
  end
end
