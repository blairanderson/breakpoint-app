class PracticeSessionsController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:set_availability]
  before_action :only => [:set_availability] do
    set_current_tenant(Team.find(params[:team_id]))
  end

  def set_availability
    @practice_session = Practice.practice_session_from_token(params[:token])
    @practice_session.available = params[:available] == 'yes'
    @practice_session.team = current_team if @practice_session.new_record?
    @practice_session.save

    sign_in :user, @practice_session.user
    response = @practice_session.available? ? "yes" : "no"
    date = l(@practice_session.practice.date, :format => :long)
    message = "Your #{response} response has been recorded for the practice on #{date}"
    redirect_to team_practices_url(current_team), notice: message
  rescue Practice::PracticeSessionTokenExpired
    session['user_return_to'] = team_practices_url(current_team)
    redirect_to new_user_session_url, :alert => "The link you tried has expired. Please sign in to set your availability."
  end

  def create
    @practice = Practice.find(params[:practice_id])
    @practice_session = @practice.practice_sessions.build(permitted_params.practice_sessions)
    @practice_session.team = current_team
    @practice_session.user = current_user
    @practice_session.save

    redirect_to team_practices_url(@practice.team)
  end

  def update
    @practice_session = PracticeSession.find(params[:id])

    if @practice_session.update_attributes(permitted_params.practice_sessions)
      redirect_to team_practices_url(current_team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_practices_url(current_team)
    end
  end
end

