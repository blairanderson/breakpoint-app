class MatchAvailabilitiesController < ApplicationController
  layout 'team'
  before_filter :load_match, :except => [:index]

  def index
    @team = Team.find(params[:team_id])
  end

  def create
    @match_availability = @match.match_availabilities.build(permitted_params.match_availabilities)
    @match_availability.user = current_user
    @match_availability.save

    redirect_to team_matches_url(@match.team)
  end

  def update
    @match_availability = MatchAvailability.find(params[:id])
    if @match_availability.update_attributes(permitted_params.match_availabilities)
      redirect_to team_matches_url(@match.team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_matches_url(@match.team)
    end
  end

  def destroy
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    @match_availability.destroy

    redirect_to team_matches_url(@match.team)
  end

  private

  def load_match
    @match = Match.find(params[:match_id])
  end
end

