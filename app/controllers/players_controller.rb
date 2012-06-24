class PlayersController < ApplicationController
  load_and_authorize_resource :season
  
  def index
    @players = @season.users
    @users = User.all
  end

  def update
    @season.user_ids = params[:player_ids]
    @season.save

    redirect_to @season, :notice => 'Players updated'
  end
end