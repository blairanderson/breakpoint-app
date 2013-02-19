class TeamMembersController < ApplicationController
  layout 'season'

  def index
    @season = Season.find(params[:season_id])
  end
end

