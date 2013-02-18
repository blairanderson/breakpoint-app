class PracticesController < ApplicationController
  def new
    @season = Season.find(params[:season_id])
    @practice = @season.practices.build
  end

  def edit
    @practice = Practice.find(params[:id])
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
      redirect_to season_url(@practice.season), :notice => 'Notification email sent to team.'
    else
      redirect_to season_url(@practice.season), :notice => 'Team has already been notified.'
    end
  end

  def create
    @season = Season.find(params[:season_id])
    # TODO authorize season
    @practice = @season.practices.build(params[:practice])

    if @practice.save
      redirect_to season_url(@season), :notice => 'Practice created'
    else
      render :new
    end
  end

  def update
    @practice = Practice.find(params[:id])

    if @practice.update_attributes(params[:practice])
      @practice.reset_notified! if @practice.previous_changes.present?
      redirect_to season_url(@practice.season), :notice => 'Practice updated'
    else
      render :edit
    end
  end

  def destroy
    @practice = Practice.find(params[:id])
    @practice.destroy

    redirect_to season_url(@practice.season), :notice => 'Practice deleted'
  end
end

