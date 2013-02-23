class TeamMembersController < ApplicationController
  layout 'team'

  def index
    @team = Team.find(params[:team_id])
  end
end

