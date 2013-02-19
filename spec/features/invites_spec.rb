require 'spec_helper'

describe 'invites' do
  before :each do
    login_captain
    @user2 = create(:user2)
    @season = create(:season, :users => [@captain])
    visit season_invites_path(@season)
  end

  it 'invites users already in the system' do
    fill_in 'search', :with => 'dave'
    click_button 'Search'

    page.should have_content 'Found users'
    click_button 'Invite'

    page.should have_content 'Invited users'
    page.should have_content 'dave.kroondyk@example.com'
  end

  it 'invites users not in the system' do
    fill_in 'search', :with => 'new_user@example.com'
    click_button 'Search'

    page.should have_content 'has no account yet'
    click_button 'Invite'

    page.should have_selector '.alert.alert-success', :text => 'Invite sent'
    page.should have_content 'Invited users'
    page.should have_content 'new_user@example.com'
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

