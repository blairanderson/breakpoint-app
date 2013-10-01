class Api::PostmarkController < ApplicationController
  skip_before_filter :authenticate_user!

  def inbound
    request.body.rewind
    email = TeamEmail.create_from_inbound_hook(request.body.read)
    if email.valid?
      client = Postmark::ApiClient.new(ENV['SIMPLE_POSTMARK_API_KEY'], secure: true)
      messages = email.team.team_emails.map do |team_member_email|
        next if email.from == team_member_email
        {
          from:      "#{email.from_name} <#{ActionMailer::Base.default[:from]}>",
          reply_to:  email.to,
          to:        team_member_email,
          subject:   email.subject,
          text_body: email.text_body,
          html_body: email.html_body
        }
      end

      client.deliver_in_batches(messages)
      render text: "Success", status: 200
    else
      render text: "Not valid", status: 200
    end
  end
end

