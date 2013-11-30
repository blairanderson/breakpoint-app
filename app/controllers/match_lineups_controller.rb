class MatchLineupsController < ApplicationController
  layout 'team'

  def edit
    @match = Match.find(params[:id])
    authorize current_team, :update?
  end
end

