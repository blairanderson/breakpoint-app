class PlayersController < ApplicationController
  def index
    @season = Season.find(params[:season_id])
    @players = @season.users
    @users = User.order(:last_name)
  end

  def update
    @season = Season.find(params[:season_id])
    @season.user_ids = params[:player_ids]
    @season.save

    redirect_to @season, :notice => 'Players updated'
  end
end

