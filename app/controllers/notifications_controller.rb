class NotificationsController < ApplicationController
  load_and_authorize_resource :practice
  load_and_authorize_resource :match
  load_and_authorize_resource :match_lineup

  def new
    @notification = Notification.new
    @notification.set_notifier(@practice, @match, @match_lineup)
  end

  def create
    @notification = Notification.new(params[:notification])
    @notification.set_notifier(@practice, @match, @match_lineup)

    if @notification.deliver
      redirect_to @notification.notifier.season, :notice => 'Notification sent'
    else
      render :new
    end
  end
end

