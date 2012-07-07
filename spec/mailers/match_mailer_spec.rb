require "spec_helper"

describe MatchMailer do
  before :each do
    user = create(:user)
    user2 = create(:user2)
    season = create(:season, :users => [user, user2]) 
    @match = create(:match, :season => season)
  end

  it 'sends match scheduled email' do
    email = MatchMailer.match_scheduled(@match).deliver
    
    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should eq 'New match scheduled'
    email.encoded.should match /<h1>New match scheduled for/
  end

  it 'sends match updated email' do
    email = MatchMailer.match_updated(@match).deliver

    ActionMailer::Base.deliveries.should_not be_empty
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should eq 'Match updated'
    email.encoded.should match /<h1>Match scheduled for/
  end
end
