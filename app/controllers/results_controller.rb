class ResultsController < ApplicationController
  layout 'team'

  def index
    @team = Team.find(params[:team_id])
    @matches = @team.matches.order('date asc')
  end

  def edit
    @match = Match.find(params[:id])
    @team = @match.team
  end
end

