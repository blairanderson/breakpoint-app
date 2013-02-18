class MatchLineupsController < ApplicationController
  layout 'season'

  def edit
    @match = Match.find(params[:id])
    @season = @match.season
  end
end

