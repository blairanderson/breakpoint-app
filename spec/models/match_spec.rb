require 'spec_helper'

describe Match do
  it 'accepts a string for date' do
    tomorrow_at_7pm = Time.new Time.now.year, Time.now.month, Time.now.day + 1, 19
    match = Match.new :date_string => 'tomorrow at 7pm', :location => 'home', :opponent => 'Paxton'
    match.date.should eq(tomorrow_at_7pm)
  end

  it 'creates a blank match lineup based off season settings' do
    match = create(:match)
    match.match_lineups.count.should eq(8)
    match.match_lineups[0].match_type.should eq('#1 Singles')
    match.match_lineups[1].match_type.should eq('#2 Singles')
    match.match_lineups[2].match_type.should eq('#1 Doubles')
    match.match_lineups[3].match_type.should eq('#1 Doubles')
    match.match_lineups[4].match_type.should eq('#2 Doubles')
    match.match_lineups[5].match_type.should eq('#2 Doubles')
    match.match_lineups[6].match_type.should eq('#3 Doubles')
    match.match_lineups[7].match_type.should eq('#3 Doubles')
  end
end
