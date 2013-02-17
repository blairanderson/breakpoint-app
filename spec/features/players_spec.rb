require 'spec_helper'

describe 'players' do
  before :each do
    login_admin
    @player = create(:player)
    @user2 = create(:user2)
    visit season_path(@player.season)
  end

  it 'shows players in a season' do
    page.should have_content 'John Doe'
  end

  it 'updates players in a season' do
    click_link 'Add players'
    check "player_id_#{@user2.id}"
    click_button 'Save Players'

    page.should have_selector '.alert.alert-success', :text => 'Players updated'
    page.should have_content 'John Doe'
    page.should have_content 'Dave Kroondyk'
  end
end