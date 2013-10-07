class Api::PostmarkController < ApplicationController
  protect_from_forgery except: [:inbound, :bounce]
  skip_before_action :authenticate_user!

  def inbound
    request.body.rewind
    email = ReceivesInboundEmail.receive(request.body.read)
    if email.valid?
      Rails.logger.info "----------------------------------------------"
      Rails.logger.info "valid?: yes"
      Rails.logger.info "----------------------------------------------"
      TeamMailer.new(email).deliver
      render text: "Success", status: 200
    else
      render text: "Not valid", status: 200
    end
  end

  def bounce
    request.body.rewind
    bounce = ReceivesBouncedEmail.receive(request.body.read)
    bounce.notify
    render text: "Success", status: 200
  end
end

