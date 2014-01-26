require "spec_helper"

describe MatchMailer do
  before :each do
    user = create(:user)
    user2 = create(:user2)
    @team = create(:team, :users => [user, user2])
    ActsAsTenant.current_tenant = @team
    @match = create(:match)
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  it 'sends match scheduled email' do
    email = MatchMailer.match_scheduled(@team.id, @match.id).deliver

    last_email.should_not be_nil
    email.to.should =~ ['team-email@mail.breakpointapp.com']
    email.subject.should eq "[#{@match.team.name}] New match scheduled"
    email.encoded.should match /<h3>When:/
  end

  it 'sends match updated email', :versioning => true do
    email = MatchMailer.match_updated(@team.id, @match.id, @match.recent_changes).deliver

    last_email.should_not be_nil
    email.to.should =~ ['team-email@mail.breakpointapp.com']
    email.subject.should eq "[#{@match.team.name}] Match updated"
    email.encoded.should match /<h3>When: /
  end
end

