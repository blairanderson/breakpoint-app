require 'spec_helper'

describe TeamMember do
  it 'sets proper status' do
    user = create(:user)
    team = create(:team)
    team.team_members.create(:user => user, :state => 'active')
    team_member = user.team_members.first

    team_member.new?.should be false
    team_member.active?.should be true
    team_member.inactive?.should be false
  end
end

