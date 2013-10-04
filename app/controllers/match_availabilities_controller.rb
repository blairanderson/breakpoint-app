class MatchAvailabilitiesController < ApplicationController
  layout 'team'
  before_action :load_match, :except => [:index]

  def index
  end

  def create
    @match_availability = @match.match_availabilities.build(permitted_params.match_availabilities)
    @match_availability.team = current_team
    @match_availability.user = current_user
    @match_availability.save

    redirect_to team_matches_url(@match.team)
  end

  def update
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    if @match_availability.update_attributes(permitted_params.match_availabilities)
      redirect_to team_matches_url(@match.team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_matches_url(@match.team)
    end
  end

  private

  def load_match
    @match = Match.find(params[:match_id])
  end
end

