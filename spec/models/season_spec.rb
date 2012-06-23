require 'spec_helper'

describe Season do
  it 'returns upcoming practices' do
    season = create(:season)
    practice = create(:practice, :season => season)
    practice2 = create(:practice_in_past, :season => season)

    season.practices.count.should eq(2)
    season.upcoming_practices.count.should eq(1)
  end
end
