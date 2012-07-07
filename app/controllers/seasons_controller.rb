class SeasonsController < ApplicationController
  load_and_authorize_resource

  def index
    @seasons = @seasons.newest
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @season.save
      redirect_to @season, :notice => 'Season created'
    else
      render :new
    end
  end

  def update
    if @season.update_attributes(params[:season])
      redirect_to seasons_url, :notice => 'Season updated'
    else
      render :edit
    end
  end

  def destroy
    @season.destroy

    redirect_to seasons_url, :notice => 'Season deleted'
  end
end