class PracticesController < ApplicationController
  load_and_authorize_resource :season
  load_and_authorize_resource :practice, :through => :season

  def new
  end

  def edit
  end

  def create
    if @practice.save
      redirect_to @season, :notice => 'Practice created'
    else
      render :new
    end
  end

  def update
    if @practice.update_attributes(params[:practice])
      redirect_to @season, :notice => 'Practice updated'
    else
      render :edit
    end
  end

  def destroy
    @practice.destroy

    redirect_to @season, :notice => 'Practice deleted'
  end
end