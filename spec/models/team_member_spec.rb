require 'spec_helper'

describe TeamMember do
  it 'sets proper status' do
    user = create(:user)
    team = create(:team, :users => [user])
    team_member = user.team_members.first

    team_member.active?.should be true
    team_member.receive_email?.should be true

    team_member.status = TeamMember::ActiveNoEmail
    team_member.save
    team_member.active?.should be true
    team_member.receive_email?.should be false
    
    team_member.status = TeamMember::Inactive
    team_member.save
    team_member.active?.should be false
    team_member.receive_email?.should be false
  end
end

