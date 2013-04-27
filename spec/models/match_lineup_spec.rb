require 'spec_helper'

describe MatchLineup do
  it 'stores results in match_sets' do
    user = create(:user)
    team = create(:team, :users => [user])
    match = create(:match, :team => team)

    match.match_lineups.each do |lineup|
      lineup.match_sets.create(:games_won => 6, :games_lost => 2, :ordinal => 1)
      lineup.match_sets.count.should eq 1
    end
  end
end

