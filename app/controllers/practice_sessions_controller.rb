class PracticeSessionsController < ApplicationController
  before_action :load_practice

  def create
    @practice_session = @practice.practice_sessions.build(permitted_params.practice_sessions)
    @practice_session.team = current_team
    @practice_session.user = current_user
    @practice_session.save

    redirect_to team_practices_url(@practice.team)
  end

  def update
    @practice_session = PracticeSession.find(params[:id])

    if @practice_session.update_attributes(permitted_params.practice_sessions)
      redirect_to team_practices_url(@practice.team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_practices_url(@practice.team)
    end
  end

  private

  def load_practice
    @practice = Practice.find(params[:practice_id])
  end
end
