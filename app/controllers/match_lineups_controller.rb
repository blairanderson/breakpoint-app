class MatchLineupsController < ApplicationController
  def edit
    @match = Match.find(params[:id])
  end
end

