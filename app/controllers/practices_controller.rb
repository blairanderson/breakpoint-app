class PracticesController < ApplicationController
  layout 'team'

  def index
    @team = Team.find(params[:team_id])
  end

  def new
    @team = Team.find(params[:team_id])
    @practice = @team.practices.build
    Chronic.time_class = Time.zone
    @practice.date = Chronic.parse('this 02:30 PM')
  end

  def edit
    @practice = Practice.find(params[:id])
    @team = @practice.team
  end

  def notify
    @practice = Practice.find(params[:id])
    if !@practice.notified_team?
      if @practice.created?
        PracticeMailer.practice_scheduled(@practice).deliver
      else
        PracticeMailer.practice_updated(@practice).deliver
      end
      @practice.notified!
      redirect_to team_practices_url(@practice.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_practices_url(@practice.team), :notice => 'Team has already been notified'
    end
  end

  def create
    @team = Team.find(params[:team_id])
    # TODO authorize team
    @practice = @team.practices.build(permitted_params.practice)

    if @practice.save
      redirect_to team_practices_url(@team), :notice => 'Practice created'
    else
      render :new
    end
  end

  def update
    @practice = Practice.find(params[:id])

    if @practice.update_attributes(permitted_params.practice)
      @practice.reset_notified! if @practice.previous_changes.present?
      redirect_to team_practices_url(@practice.team), :notice => 'Practice updated'
    else
      @team = @practice.team
      render :edit
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy

    redirect_to team_practices_url(@practice.team), :notice => 'Practice deleted'
  end
end

