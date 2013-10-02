class Api::PostmarkController < ApplicationController
  protect_from_forgery except: :inbound
  skip_before_filter :authenticate_user!

  def inbound
    request.body.rewind
    email = ReceivesInboundEmail.receive(request.body.read)
    if email.valid?
      TeamMailer.new(email).deliver
      render text: "Success", status: 200
    else
      render text: "Not valid", status: 200
    end
  end
end

