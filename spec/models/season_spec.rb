require 'spec_helper'

describe Season do
  it 'returns upcoming practices' do
    season = create(:season)
    practice = create(:practice, :season => season)
    practice2 = create(:practice_in_past, :season => season)

    season.practices.count.should eq(2)
    season.upcoming_practices.count.should eq(1)
  end

  it 'returns upcoming matches' do
    season = create(:season)
    match = create(:match, :season => season)
    match2 = create(:match_in_past, :season => season)

    season.matches.count.should eq(2)
    season.upcoming_matches.count.should eq(1)
  end

  it 'returns team emails' do
    user = create(:user)
    user2 = create(:user2)
    season = create(:season, :users => [user, user2])

    season.team_emails.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
  end
end

# == Schema Information
#
# Table name: seasons
#
#  created_at      :datetime         not null
#  date            :datetime         not null
#  doubles_matches :integer          not null
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  singles_matches :integer          not null
#  updated_at      :datetime         not null
#

