require 'spec_helper'

describe 'invites' do
  before :each do
    login_captain
    @user2 = create(:user2)
    @team = create(:team, :users => [@captain])
    visit team_invites_path(@team)
  end

  it 'invites users already in the system' do
    fill_in 'search', :with => 'dave'
    click_button 'Search'

    page.should have_content 'Found users'
    click_button 'Invite'

    last_email.subject.should == "[#{@team.name}] #{@captain.name} invited you to the team"
    page.should have_content 'Invited users'
    page.should have_content 'Dave Kroondyk'
  end

  it 'allows searching by name' do
    fill_in 'search', :with => 'captain'
    click_button 'Search'
    page.should have_selector '.label.label-info', :text => 'On team'
  end

  it 'allows searching by name with unique results' do
    fill_in 'search', :with => 'captain captain'
    click_button 'Search'
    page.should have_selector '.label.label-info', :text => 'On team', :count => 1
  end

  it 'allows searching by name case insensitive' do
    fill_in 'search', :with => 'Captain'
    click_button 'Search'
    page.should have_selector '.label.label-info', :text => 'On team'
  end

  it 'invites users not in the system' do
    fill_in 'search', :with => 'new_user@example.com'
    click_button 'Search'

    page.should have_content 'has no account yet'
    click_button 'Invite'

    last_email.subject.should == "[#{@team.name}] #{@captain.name} invited you to the team"
    page.should have_selector '.alert.alert-success', :text => 'Invite sent'
    page.should have_content 'Invited users'
    page.should have_content 'New User'
  end

  it 'invites users not in the system and override the name' do
    fill_in 'search', :with => 'new_user123@example.com'
    click_button 'Search'

    page.should have_content 'has no account yet'
    fill_in 'name', :with => 'Custom Name'
    click_button 'Invite'

    last_email.subject.should == "[#{@team.name}] #{@captain.name} invited you to the team"
    page.should have_selector '.alert.alert-success', :text => 'Invite sent'
    page.should have_content 'Invited users'
    page.should have_content 'Custom Name'
    page.should_not have_content 'New User'
  end

  it 'does not allow inviting a user already on the team' do
    fill_in 'search', :with => @captain.first_name
    click_button 'Search'

    page.should have_selector '.label.label-info', :text => 'On team'
  end

  it 'does not allow inviting a user already invited' do
    fill_in 'search', :with => 'new_user123@example.com'
    click_button 'Search'
    click_button 'Invite'
    fill_in 'search', :with => 'New'
    click_button 'Search'

    page.should have_selector '.label.label-info', :text => 'Invited'
  end

  it 'accepts an invite' do
    invite = create(:invite, :user => @user2, :invited_by => @captain, :team => @team)
    logout
    login(@user2)

    visit teams_path
    page.should have_content 'not on any teams'
    page.should have_content 'invited to the team'
    click_button 'Accept'
    page.should have_selector '.alert.alert-success', :text => 'Invite accepted'
    visit teams_path
    page.should_not have_content 'not on any teams'
  end

  it 'deletes an invite' do
    fill_in 'search', :with => 'dave'
    click_button 'Search'
    click_button 'Invite'
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Invite deleted'
    page.should_not have_content 'dave.kroondyk@example.com'
  end
end

