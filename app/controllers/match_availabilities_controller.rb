class MatchAvailabilitiesController < ApplicationController
  def create
    @match = Match.find(params[:match_id])
    @match_availability = @match.match_availabilities.build(params[:match_availability])
    @match_availability.user = current_user
    @match_availability.save

    redirect_to team_matches_url(@match.team)
  end

  def destroy
    @match = Match.find(params[:match_id])
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    @match_availability.destroy

    redirect_to team_matches_url(@match.team)
  end
end

