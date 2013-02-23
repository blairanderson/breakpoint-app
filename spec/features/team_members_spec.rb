require 'spec_helper'

describe 'team members' do
  before :each do
    login_captain
    @team_member = create(:team_member)
    @user2 = create(:user2)
    visit team_team_members_path(@team_member.team)
  end

  it 'shows team members in a team' do
    page.should have_content 'John Doe'
  end
end

