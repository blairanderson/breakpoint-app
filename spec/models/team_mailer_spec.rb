require 'spec_helper'

describe TeamMailer do
  it 'sends email to all team members, but not to the sender' do
    email = stub(from:        "dave@example.com",
                 from_name:   "Dave",
                 to:          "team@mail.breakpointapp.com",
                 subject:     "test",
                 text_body:   "test",
                 html_body:   "&lt;p&gt;test&lt;/p&gt;",
                 attachments: [{name: "myimage.png", content: "[BASE64-ENCODED CONTENT]", content_type: "image/png"}],
                 team:        stub(:team_emails => ["dave@example.com", "john@example.com", "steve@example.com"]))
    mailer = TeamMailer.new(email)
    message = {
      from:        "Dave <#{ActionMailer::Base.default[:from]}>",
      to:          "team@mail.breakpointapp.com",
      bcc:         ["john@example.com", "steve@example.com"],
      subject:     "test",
      text_body:   "test",
      html_body:   "<p>test</p>",
      tag:         "generated-by-app",
      attachments: [{name: "myimage.png", content: "[BASE64-ENCODED CONTENT]", content_type: "image/png"}]
    }

    mailer.send(:message, ["john@example.com", "steve@example.com"]).should eq message
  end
end

