class SeasonsController < ApplicationController
  def index
    @seasons = Season.newest
  end

  def show
    @season = Season.find params[:id]
  end

  def new
    @season = Season.new
  end

  def edit
    @season = Season.find params[:id]
  end

  def create
    @season = Season.new params[:season]

    if @season.save
      redirect_to seasons_path, :notice => 'Season created'
    else
      render :new
    end
  end

  def update
    @season = Season.find params[:id]

    if @season.update_attributes(params[:season])
      redirect_to seasons_path, :notice => 'Season updated'
    else
      render :edit
    end
  end

  def destroy
    @season = Season.find params[:id]
    @season.destroy

    redirect_to seasons_path, :notice => 'Season deleted'
  end
end