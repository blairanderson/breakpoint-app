require 'spec_helper'

describe 'match_availabilities' do
  before :each do
    login_captain
    @match = create(:match)
    @old_match = create(:match_in_past)
    visit team_matches_path(@match.team)
  end

  it 'creates a match_availability' do
    page.should have_content 'There are no available players yet'
    click_button 'I can play'
    page.should have_content "I can't play"
    page.should have_content 'Available players'
  end

  it 'deletes a match_availability' do
    click_button 'I can play'
    page.should have_content 'Available players'

    click_link "I can't play"
    page.should have_content 'There are no available players yet'
  end
end

