require 'spec_helper'

describe 'match_availabilities' do
  before :each do
    login_captain
    ActsAsTenant.current_tenant = create(:team)
    @match = create(:match, team: ActsAsTenant.current_tenant)
    @match.team.team_members.create(:user => @captain, :role => 'captain', :state => 'active')
    ActsAsTenant.current_tenant = nil
    visit team_matches_path(@match.team)
  end

  it 'lists all match_availabilities' do
    click_link 'See who can play when'
    page.should have_selector '.label', :text => 'n/a'

    visit team_matches_path(@match.team)
    click_button "I can't play"
    click_link 'See who can play when'
    page.should have_selector '.label-danger', :text => 'no'

    visit team_matches_path(@match.team)
    click_button 'I can play'
    click_link 'See who can play when'
    page.should have_selector '.label-success', :text => 'yes'
  end

  it 'creates a match_availability as available' do
    click_button 'I can play'
    page.should have_content 'You can play'
  end

  it 'creates a match_availability as not available' do
    click_button "I can't play"
    page.should have_content "You can't play"
  end

  it 'toggles match_availability' do
    click_button 'I can play'
    page.should have_content 'You can play'

    click_button "I can't play"
    page.should have_content "You can't play"
  end
end

