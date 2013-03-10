require "spec_helper"

describe MatchMailer do
  before :each do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])
    @match = create(:match, :team => team)
  end

  it 'sends match scheduled email' do
    email = MatchMailer.match_scheduled(@match).deliver

    last_email.should_not be_nil
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should eq 'New match scheduled'
    email.encoded.should match /<h1>New match scheduled for/
  end

  it 'sends match updated email' do
    email = MatchMailer.match_updated(@match, @match.recent_changes).deliver

    last_email.should_not be_nil
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should eq 'Match updated'
    email.encoded.should match /<h1>Match scheduled for/
  end
end

