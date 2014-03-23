require 'spec_helper'

describe 'team members' do
  before :each do
    login_captain
    create_team_with_captain_and_member
    visit team_team_members_path(@team)
  end

  it 'edit team members role' do
    page.should have_content 'Captain'
    find("a[href='#{edit_team_team_member_path(@team, @captain_member)}']").click
    select 'Member', :from => 'team_member_role'
    click_button 'Save settings'
    page.should have_content 'Team member updated'
    page.should have_content 'Member'
    page.should_not have_content 'Captain'
  end

  it 'team member deactivates self' do
    click_link 'Sign out'
    login @user2
    visit team_team_members_path(@team)
    click_link 'Edit'
    click_button 'Deactivate team membership'
    page.should have_selector '.alert.alert-success', :text => 'You have been just removed yourself from the team.'
  end

  it 'captain can deactive team member' do
    visit team_team_members_path(@team)
    find("a[href='#{edit_team_team_member_path(@team, @member)}']").click
    click_button 'Deactivate team membership'
    page.should have_selector '.alert.alert-success', :text => 'Team member is now inactive'
  end
end

def create_team_with_captain_and_member
  @team = create(:team)
  ActsAsTenant.current_tenant = @team
  @captain_member = @team.team_members.create(:user => @captain, :role => 'captain', :state => 'active')
  @user2 = create(:user2)
  @member = @team.team_members.create(:user => @user2, :role => 'member', :state => 'active')
  ActsAsTenant.current_tenant = nil
end

