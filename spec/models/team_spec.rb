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

  it 'returns active users for team members who are active' do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])
    user2.team_members.first.update_attribute(:active, false)

    team.active_users.should eq [user]
  end

  it 'returns team emails for team members who receive emails' do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])
    user2.team_members.first.update_attribute(:receive_email, false)

    team.team_emails.should eq ['john.doe@example.com']
  end

  it 'returns team members who accepted and not accepted their invite' do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2])
    invite = create(:invite, :user => user, :team => team, :invited_by => user, :accepted_at => Time.now)
    invite = create(:invite, :user => user2, :team => team, :invited_by => user)

    team.accepted_team_members.collect(&:user_id).should eq [user.id]
    team.not_accepted_team_members.collect(&:user_id).should eq [user2.id]
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

