require 'spec_helper'

describe Match do
  it 'accepts a string for date' do
    tomorrow_at_7pm = Time.new Time.now.year, Time.now.month, Time.now.day + 1, 19
    match = Match.new :date_string => 'tomorrow at 7pm', :location => 'home', :opponent => 'Paxton'
    match.date.should eq(tomorrow_at_7pm)
  end
end
