class SeasonsController < ApplicationController
  before_filter :load_seasons, :only => 'index'
  load_and_authorize_resource

  def index
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
      redirect_to seasons_path, :notice => 'Season updated'
    else
      render :edit
    end
  end

  def destroy
    @season.destroy

    redirect_to seasons_path, :notice => 'Season deleted'
  end

  private

  def load_seasons
    @seasons = Season.newest
  end
end