class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
  end

  def create
    @user = User.new params[:user]

    if @user.save
      redirect_to users_path, :notice => 'User created'
    else
      render :new
    end
  end

  def update
    @user = User.find params[:id]

    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice => 'User updated'
    else
      render :edit
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.destroy

    redirect_to users_path, :notice => 'User deleted'
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to users_path, :alert => 'Cannot delete user because of they belong to a season'
  end
end