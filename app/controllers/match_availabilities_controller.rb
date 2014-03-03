class MatchAvailabilitiesController < ApplicationController
  layout 'team'
  skip_before_action :authenticate_user!, :only => [:set_availability]
  before_action :only => [:set_availability] do
    set_current_tenant(Team.find(params[:team_id]))
  end

  def index
  end

  def set_availability
    @match_availability = Match.match_availability_from_token(params[:token])
    @match_availability.available = params[:available] == 'yes'
    @match_availability.team = current_team if @match_availability.new_record?
    @match_availability.save

    sign_in :user, @match_availability.user
    response = @match_availability.available? ? "yes" : "no"
    date = l(@match_availability.match.date, :format => :long)
    message = "Your #{response} response has been recorded for the match on #{date}"
    redirect_to team_matches_url(current_team), notice: message
  rescue Match::MatchAvailabilityTokenExpired
    session['user_return_to'] = team_matches_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end

  def create
    @match = Match.find(params[:match_id])
    @match_availability = @match.match_availabilities.build(permitted_params.match_availabilities)
    @match_availability.team = current_team
    @match_availability.user = current_user
    @match_availability.save

    redirect_to team_matches_url(current_team)
  end

  def update
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    if @match_availability.update_attributes(permitted_params.match_availabilities)
      redirect_to team_matches_url(current_team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_matches_url(current_team)
    end
  end
end

