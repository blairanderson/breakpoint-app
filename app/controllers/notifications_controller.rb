class NotificationsController < ApplicationController
  def new
    @practice = Practice.find(params[:practice_id]) if params[:practice_id].present?
    @match = Match.find(params[:match_id]) if params[:match_id].present?
    @notification = Notification.new
    @notification.set_notifier(@practice, @match)
  end

  def create
    @practice = Practice.find(params[:practice_id]) if params[:practice_id].present?
    @match = Match.find(params[:match_id]) if params[:match_id].present?
    @notification = Notification.new(params[:notification])
    @notification.set_notifier(@practice, @match)

    if @notification.deliver
      redirect_to @notification.notifier.season, :notice => 'Notification sent'
    else
      render :new
    end
  end
end

