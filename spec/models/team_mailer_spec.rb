require 'spec_helper'

describe TeamMailer do
  it 'sends email to all team members, but not to the sender' do
    email = stub(:from      => "dave@example.com",
                 :from_name => "Dave",
                 :to        => "team@mail.breakpointapp.com",
                 :subject   => "test",
                 :text_body => "test",
                 :html_body => "&lt;p&gt;test&lt;/p&gt;",
                 :team      => stub(:team_emails => ["dave@example.com", "john@example.com", "steve@example.com"]))
    mailer = TeamMailer.new(email)
    messages = [
      {
        from:      "Dave <#{ActionMailer::Base.default[:from]}>",
        reply_to:  "team@mail.breakpointapp.com",
        to:        "john@example.com",
        subject:   "test",
        text_body: "test",
        html_body: "<p>test</p>"
      },
      {
        from:      "Dave <#{ActionMailer::Base.default[:from]}>",
        reply_to:  "team@mail.breakpointapp.com",
        to:        "steve@example.com",
        subject:   "test",
        text_body: "test",
        html_body: "<p>test</p>"
      }
    ]

    mailer.send(:messages).should eq messages
  end
end

