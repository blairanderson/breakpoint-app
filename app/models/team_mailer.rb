class TeamMailer
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def deliver
    client = Postmark::ApiClient.new(ENV['SIMPLE_POSTMARK_API_KEY'], secure: true)
    team_emails.in_groups_of(20, false).each do |group|
      client.deliver(message(group))
    end
  end

  private

  def team_emails
    remove_sender(email.team.team_emails)
  end

  def remove_sender(emails)
    emails.reject { |e| email.from == e }
  end

  def message(bcc)
    {
      from:        "#{email.from_name} <#{ActionMailer::Base.default[:from]}>",
      to:          email.to,
      bcc:         bcc,
      subject:     email.subject,
      text_body:   email.text_body,
      html_body:   CGI::unescapeHTML(email.html_body),
      tag:         "generated-by-app",
      attachments: email.attachments
    }
  end
end

