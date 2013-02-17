class PracticesController < ApplicationController
  def new
    @season = Season.find(params[:season_id])
    @practice = @season.practices.build
  end

  def edit
    @practice = Practice.find(params[:id])
  end

  def create
    @season = Season.find(params[:season_id])
    # TODO authorize season
    @practice = @season.practices.build(params[:practice])

    if @practice.save
      redirect_to season_url(@season), :notice => 'Practice created'
    else
      render :new
    end
  end

  def update
    @practice = Practice.find(params[:id])

    if @practice.update_attributes(params[:practice])
      redirect_to season_url(@practice.season), :notice => 'Practice updated'
    else
      render :edit
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy

    redirect_to season_url(@practice.season), :notice => 'Practice deleted'
  end
end

