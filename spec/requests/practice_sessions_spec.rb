require 'spec_helper'

describe 'practice_sessions' do
  before :each do
    login_admin
    @practice = create(:practice)
    visit season_path(@practice.season)
  end

  it 'creates a practice_session' do
    page.should have_content 'There are no confirmed players yet'
    click_button "I'm going"
    page.should have_content "I'm not going"
    page.should have_content 'Confirmed players'
  end

  it 'deletes a practice_session' do
    click_button "I'm going"
    page.should have_content 'Confirmed players'

    click_link "I'm not going"
    page.should have_content 'There are no confirmed players yet'
  end
end