class MatchLineupsController < ApplicationController
  layout 'team'

  def edit
    @match = Match.find(params[:id])
  end
end

