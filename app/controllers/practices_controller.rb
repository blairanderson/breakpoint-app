class PracticesController < ApplicationController
  layout 'team'

  def index
    @practices = current_team.practices
  end

  def new
    @practice = current_team.practices.build
  end

  def edit
    @practice = Practice.find(params[:id])
  end

  def notify
    @practice = Practice.find(params[:id])
    if !@practice.notified_team?
      if @practice.created?
        PracticeMailer.delay.practice_scheduled(current_team.id, @practice.id)
      else
        PracticeMailer.delay.practice_updated(current_team.id, @practice.id, @practice.recent_changes)
      end
      @practice.notified!
      redirect_to team_practices_url(@practice.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_practices_url(@practice.team), :notice => 'Team has already been notified'
    end
  end

  def create
    @practice = current_team.practices.build(permitted_params.practice)

    if @practice.save
      redirect_to team_practices_url(current_team), :notice => 'Practice created'
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
      render :edit
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy

    redirect_to team_practices_url(@practice.team), :notice => 'Practice deleted'
  end
end

