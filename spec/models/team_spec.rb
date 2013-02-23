require 'spec_helper'

describe Team do
  it 'returns upcoming practices' do
    team = create(:team)
    practice = create(:practice, :team => team)
    practice2 = create(:practice_in_past, :team => team)

    team.practices.count.should eq(2)
    team.upcoming_practices.count.should eq(1)
  end

  it 'returns upcoming matches' do
    team = create(:team)
    match = create(:match, :team => team)
    match2 = create(:match_in_past, :team => team)

    team.matches.count.should eq(2)
    team.upcoming_matches.count.should eq(1)
  end

  it 'returns team emails' do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])

    team.team_emails.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
  end
end

# == Schema Information
#
# Table name: teams
#
#  created_at      :datetime         not null
#  date            :datetime         not null
#  doubles_matches :integer          not null
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  singles_matches :integer          not null
#  updated_at      :datetime         not null
#

