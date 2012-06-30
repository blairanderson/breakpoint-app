class UsersController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def edit
  end

  def create
    if @user.save
      redirect_to users_url, :notice => 'User created'
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to users_url, :notice => 'User updated'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy

    redirect_to users_url, :notice => 'User deleted'
  rescue ActiveRecord::DeleteRestrictionError
    redirect_to users_url, :alert => 'Cannot delete user because of they belong to a season'
  end
end