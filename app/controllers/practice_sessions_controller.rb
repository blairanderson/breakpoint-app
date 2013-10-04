class PracticeSessionsController < ApplicationController
  def create
    @practice = Practice.find(params[:practice_id])
    @practice_session = @practice.practice_sessions.build
    @practice_session.team = current_team
    @practice_session.user = current_user
    @practice_session.save

    redirect_to team_practices_url(@practice.team)
  end

  def destroy
    @practice = Practice.find(params[:practice_id])
    @practice_session = PracticeSession.find(params[:id])
    authorize @practice_session

    @practice_session.destroy

    redirect_to team_practices_url(@practice.team)
  end
end

