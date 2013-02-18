class TeamMembersController < ApplicationController
  def index
    @season = Season.find(params[:season_id])
    @team_members = @season.users
    @users = User.order(:last_name)
  end

  def update
    @season = Season.find(params[:season_id])
    @season.user_ids = params[:team_member_ids]
    @season.save

    redirect_to @season, :notice => 'Team members updated'
  end
end

