class UsersController < ApplicationController
  def index
    @users = User.order(:last_name)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      redirect_to users_url, :notice => 'User created'
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to users_url, :notice => 'User updated'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url, :notice => 'User deleted'
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to users_url, :alert => 'Cannot delete user because of they belong to a season'
  end
end

