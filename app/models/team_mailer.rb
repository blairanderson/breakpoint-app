class TeamMailer
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def deliver
    client = Postmark::ApiClient.new(ENV['SIMPLE_POSTMARK_API_KEY'], secure: true)
    client.deliver_in_batches(messages)
  end

  private

  def team_emails
    remove_sender(email.team.team_emails)
  end

  def remove_sender(emails)
    emails.reject { |e| email.from == e }
  end

  def messages
    team_emails.map { |e| message(e) }
  end

  def message(to)
    {
      from:        "#{email.from_name} <#{ActionMailer::Base.default[:from]}>",
      reply_to:    email.to,
      to:          to,
      subject:     email.subject,
      text_body:   email.text_body,
      html_body:   CGI::unescapeHTML(email.html_body),
      attachments: email.attachments
    }
  end
end

