require 'spec_helper'

describe 'team members' do
  before :each do
    login_captain
    @team_member = create(:team_member)
    @user2 = create(:user2)
    visit season_path(@team_member.season)
  end

  it 'shows team members in a season' do
    page.should have_content 'John Doe'
  end

  it 'updates team members in a season' do
    click_link 'Add team members'
    check "team_member_id_#{@user2.id}"
    click_button 'Save Team Members'

    page.should have_selector '.alert.alert-success', :text => 'Team members updated'
    page.should have_content 'John Doe'
    page.should have_content 'Dave Kroondyk'
  end
end

