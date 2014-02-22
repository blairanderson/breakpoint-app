require "spec_helper"

describe MatchMailer do
  before :each do
    @user = create(:user)
    @user2 = create(:user2)
    @team = create(:team, :users => [@user, @user2])
    ActsAsTenant.current_tenant = @team
    @match = create(:match)
    @match.match_lineups.each do |lineup|
      lineup.match_players.create(:user => @user)
    end
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  let(:created_options) {
    { from: @user.name, reply_to: @user.email }
  }

  let(:updated_options) {
    { from: @user.name, reply_to: @user.email, recent_changes: [] }
  }

  it 'sends match scheduled email' do
    MatchMailer.match_scheduled(@match, @user2.email, created_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should eq "[#{@match.team.name}] New match scheduled"
    last_email.encoded.should match /<h3>When:/
  end

  it 'sends match updated email', :versioning => true do
    MatchMailer.match_updated(@match, @user2.email, updated_options).deliver

    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email.subject.should eq "[#{@match.team.name}] Match updated"
    last_email.encoded.should match /<h3>When: /
  end

  it 'sends match lineup set email' do
    MatchMailer.match_lineup_set(@match, @user2.email, created_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should match /\[#{@match.team.name}\] Lineup set for match on/
    last_email.encoded.should match /<h1>The lineup has been set/
  end

  it 'sends match lineup updated email', :versioning => true do
    MatchMailer.match_lineup_updated(@match, @user2.email, updated_options).deliver

    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email.subject.should match /\[#{@match.team.name}\] Lineup updated for match on/
    last_email.encoded.should match /<h1>The lineup was updated for/
  end
end

