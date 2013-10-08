class PracticeSessionsController < ApplicationController
  layout 'team'
  before_action :load_practice, :except => [:index]

  def index
    @team = current_user.teams.find(params[:team_id])
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
    authorize @practice_session

    if @practice_session.update_attributes(permitted_params.practice_sessions)
      redirect_to team_practices_url(@practice.team)
    else
      flash[:error] = 'Availability was not updated. Try again or contact support'
      redirect_to team_practices_url(@practice.team)
    end
  end

  def destroy
    @practice = Practice.find(params[:practice_id])
    @practice_session = PracticeSession.find(params[:id])
    authorize @practice_session

    @practice_session.destroy

    redirect_to team_practices_url(@practice.team)
  end

  private

  def load_practice
    @practice = Practice.find(params[:practice_id])
    authorize @practice, :set_availabilities?
  end
end
