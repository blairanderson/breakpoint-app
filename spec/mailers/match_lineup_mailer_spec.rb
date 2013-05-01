require "spec_helper"

describe MatchLineupMailer do
  before :each do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])
    @match = create(:match, :team => team)
    @match.match_lineups.each do |lineup|
      lineup.match_players.create(:user => user)
    end
  end

  it 'sends match lineup set email' do
    email = MatchLineupMailer.lineup_set(@match).deliver

    last_email.should_not be_nil
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should match /\[#{@match.team.name}\] Lineup set for match on/
    email.encoded.should match /<h1>The lineup has been set/
  end

  it 'sends match lineup updated email' do
    email = MatchLineupMailer.lineup_updated(@match, @match.recent_changes).deliver

    last_email.should_not be_nil
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should match /\[#{@match.team.name}\] Lineup updated for match on/
    email.encoded.should match /<h1>The lineup was updated for/
  end
end

