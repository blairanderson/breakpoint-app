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
    update_availability(params[:available])
    @match_availability.team = current_team if @match_availability.new_record?
    @match_availability.save

    sign_in :user, @match_availability.user
    response = @match_availability.state
    date = l(@match_availability.match.date, :format => :long)
    message = "Your #{response} response has been recorded for the match on #{date}"
    redirect_to team_matches_url(current_team), notice: message
  rescue Match::MatchAvailabilityTokenExpired
    session['user_return_to'] = team_matches_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end

  def update
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    update_availability(params[:state])

    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  private

  def update_availability(state)
    if state == 'yes'
      @match_availability.available!
    elsif state == 'maybe'
      @match_availability.maybe_available!
    elsif state == 'no'
      @match_availability.not_available!
    end
  end
end

