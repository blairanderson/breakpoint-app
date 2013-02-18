require 'spec_helper'

describe Match do
  it 'accepts a string for date' do
    tomorrow_at_7pm = Time.new Time.now.year, Time.now.month, Time.now.day + 1, 19
    match = Match.new :date_string => 'tomorrow at 7pm', :location => 'home', :opponent => 'Paxton'
    match.date.should eq(tomorrow_at_7pm)
  end

  it 'creates a blank match lineup based off season settings' do
    season = create(:season, :singles_matches => 1, :doubles_matches => 1)
    match = create(:match, :season => season)
    
    match.match_lineups.count.should eq(3)
    match.match_lineups[0].match_type.should eq('#1 Singles')
    match.match_lineups[1].match_type.should eq('#1 Doubles')
    match.match_lineups[2].match_type.should eq('#1 Doubles')
  end

  it 'returns team emails' do
    user = create(:user)
    user2 = create(:user2)
    season = create(:season, :users => [user, user2])
    match = create(:match, :season => season)

    match.team_emails.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
  end

  it 'returns the match availability for a specified user id' do
    user = create(:user)
    season = create(:season, :users => [user])
    match = create(:match, :season => season)
    match_availability = create(:match_availability, :match => match, :user => user)

    match.match_availability_for_user(user.id).should eq match_availability
  end
end

# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  location       :string(255)      default(""), not null
#  opponent       :string(255)      default(""), not null
#  season_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#

