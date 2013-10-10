require 'spec_helper'

describe TeamMailer do
  it 'sends email to all team members, but not to the sender' do
    user  = create(:user)
    user2 = create(:user2)
    user3 = create(:captain)
    team  = create(:team, users: [user, user2, user3])

    email = {
      team_id:     team.id,
      from:        user.email,
      from_name:   "Dave",
      to:          team.email_address,
      subject:     "test",
      text_body:   "test",
      html_body:   "&lt;p&gt;test&lt;/p&gt;",
      attachments: [{name: "myimage.png", content: "[BASE64-ENCODED CONTENT]", content_type: "image/png"}]
    }
    mailer = TeamMailer.new(email)
    message = {
      from:        "Dave <#{ActionMailer::Base.default[:from]}>",
      reply_to:    team.email_address,
      to:          team.email_address,
      bcc:         [user3.email, user2.email],
      subject:     "test",
      text_body:   "test",
      html_body:   "<p>test</p>",
      tag:         "sent-to-team",
      attachments: [{name: "myimage.png", content: "[BASE64-ENCODED CONTENT]", content_type: "image/png"}]
    }

    mailer.send(:message, mailer.send(:team_emails)).should eq message
  end
end

