require 'spec_helper'

describe Team do
  it 'validates email' do
    team = create(:team)
    team.update_attributes(email: "no_UPPER_case")
    team.valid?.should be_false

    team.update_attributes(email: "no_@_allowed")
    team.valid?.should be_false

    team.update_attributes(email: "no_!#$%^&*(_allowed")
    team.valid?.should be_false

    team.update_attributes(email: "valid-with-under_score-or-dashes")
    team.valid?.should be_true
  end

  it 'returns upcoming practices' do
    team = create(:team)
    ActsAsTenant.current_tenant = team
    practice = create(:practice)
    practice2 = create(:practice_in_past)

    team.practices.count.should eq(2)
    team.upcoming_practices.count.should eq(1)
    ActsAsTenant.current_tenant = nil
  end

  it 'returns upcoming matches' do
    team = create(:team)
    ActsAsTenant.current_tenant = team
    match = create(:match)
    match2 = create(:match_in_past)

    team.matches.count.should eq(2)
    team.upcoming_matches.count.should eq(1)
    ActsAsTenant.current_tenant = nil
  end

  it 'returns active users team emails for team members who are active' do
    user = create(:user)
    user2 = create(:user2)
    user3 = create(:captain)
    team = create(:team)
    team.team_members.create(:user => user, :state => 'new')
    team.team_members.create(:user => user2, :state => 'active')
    team.team_members.create(:user => user3, :state => 'inactive')

    team.active_users.should eq [user2]
    team.team_emails.should eq ['dave.kroondyk@example.com']
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

