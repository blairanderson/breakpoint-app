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
    @match_availability.state = params[:available]
    @match_availability.team = current_team if @match_availability.new_record?
    @match_availability.save

    sign_in :user, @match_availability.user
    response = @match_availability.state
    date = l(@match_availability.match.date, :format => :long)
    message = "Your #{response} response has been recorded. Add additional availability notes for your captain below."
    redirect_to team_match_url(current_team, @match_availability.match), notice: message
  rescue Match::MatchAvailabilityTokenExpired
    session['user_return_to'] = team_matches_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end

  def save_availability
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    @match_availability.state = params[:state]
    @match_availability.save

    respond_to do |format|
      format.js { render nothing: true }
    end
  end

  def save_note
    @match_availability = MatchAvailability.find(params[:id])
    authorize @match_availability

    if @match_availability.update_attributes(note: params[:note])
      render json: { note: @match_availability.note }
    else
      render json: { errors: @match_availability.errors.full_messages.to_sentence }, status: 422
    end
  end
end

