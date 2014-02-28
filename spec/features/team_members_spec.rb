require 'spec_helper'

describe 'team members' do
  before :each do
    login_captain
    team = create(:team)
    ActsAsTenant.current_tenant = team
    team.team_members.create(:user => @captain, :role => 'captain', :state => 'active')
    @user2 = create(:user2)
    ActsAsTenant.current_tenant = nil
    visit team_team_members_path(team)
  end

  it 'shows team members in a team' do
    page.should have_content 'captain captain'
    page.should_not have_content 'Dave Kroondyk'
  end

  it 'edit team members role' do
    page.should have_content 'Captain'
    click_link 'Edit'
    select 'Member', :from => 'team_member_role'
    click_button 'Save settings'
    page.should have_content 'Team member updated'
    page.should have_content 'Member'
    page.should_not have_content 'Captain'
  end
end

