class PracticesController < ApplicationController
  layout 'team'

  def index
    @upcoming_practices = current_team.upcoming_practices
    @previous_practices = current_team.previous_practices
  end

  def new
    @practice = current_team.practices.build
    @practice.date = Time.zone.now.change(hour: 14, min: 30)
  end

  def edit
    @practice = Practice.find(params[:id])
  end

  def availability_email
    @practice = Practice.find(params[:id])
    if !@practice.updated?
      @practice_scheduled = PracticeMailer.practice_scheduled(@practice,
                                                              current_user.email,
                                                              from:     current_user.name,
                                                              reply_to: current_user.email,
                                                              user_id:  current_user.id)
    else
      @practice_updated = PracticeMailer.practice_updated(@practice,
                                                          current_user.email,
                                                          from:           current_user.name,
                                                          reply_to:       current_user.email,
                                                          user_id:        current_user.id,
                                                          recent_changes: @practice.recent_changes)
    end
  end

  def notify
    @practice = Practice.find(params[:id])

    if @practice.created?
      Practice.delay.notify(:scheduled,
                            from:        current_user.name,
                            reply_to:    current_user.email,
                            practice_id: @practice.id)
    else
      Practice.delay.notify(:updated,
                            from:           current_user.name,
                            reply_to:       current_user.email,
                            practice_id:    @practice.id,
                            recent_changes: @practice.recent_changes)
    end

    @practice.notified!
    redirect_to team_practices_url(@practice.team), :notice => 'Availability request email sent to team'
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

