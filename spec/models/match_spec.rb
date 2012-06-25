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
end
