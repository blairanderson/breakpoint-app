require 'spec_helper'

describe 'match_availabilitys' do
  before :each do
    login_admin
    @match = create(:match)
    visit season_path(@match.season)
  end

  it 'creates a match_availability' do
    page.should have_content 'There are no available players yet'
    click_button "I can play"
    page.should have_content "I can't play"
    page.should have_content 'Available players'
  end

  it 'deletes a match_availability' do
    click_button "I can play"
    page.should have_content 'Available players'

    click_link "I can't play"
    page.should have_content 'There are no available players yet'
  end
end