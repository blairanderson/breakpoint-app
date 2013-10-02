require 'spec_helper'

describe ReceivesInboundEmail do
  it 'parses the json' do
    email = ReceivesInboundEmail.receive(File.read(File.expand_path("../team_email.json", __FILE__)))
    email.from.should       eq "myUser@theirDomain.com"
    email.from_name.should  eq "John Doe"
    email.to.should         eq "451d9b70cf9364d23ff6f9d51d870251569e+ahoy@inbound.postmarkapp.com"
    email.subject.should    eq "This is an inbound message"
    email.text_body.should  eq "[ASCII]"
    email.html_body.should  eq "[HTML(encoded)]"
    email.send(:team_email).should eq "451d9b70cf9364d23ff6f9d51d870251569e+ahoy"
  end
end

