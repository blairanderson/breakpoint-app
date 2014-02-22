require "spec_helper"

describe MatchMailer do
  before :each do
    @user = create(:user)
    @user2 = create(:user2)
    @team = create(:team, :users => [@user, @user2])
    ActsAsTenant.current_tenant = @team
    @match = create(:match)
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  it 'sends match scheduled email' do
    options = {
      from:     @user.name,
      reply_to: @user.email
    }

    MatchMailer.match_scheduled(@match, @user2.email, options).deliver

    last_email.should_not be_nil
    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should eq "[#{@match.team.name}] New match scheduled"
    last_email.encoded.should match /<h3>When:/
  end

  it 'sends match updated email', :versioning => true do
    options = {
      from:           @user.name,
      reply_to:       @user.email,
      recent_changes: []
    }

    MatchMailer.match_updated(@match, @user2.email, options).deliver

    last_email.should_not be_nil
    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email.subject.should eq "[#{@match.team.name}] Match updated"
    last_email.encoded.should match /<h3>When: /
  end
end

