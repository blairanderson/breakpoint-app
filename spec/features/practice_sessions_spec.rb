require 'spec_helper'

describe 'practice_sessions' do
  before :each do
    login_captain
    team = create(:team)
    @practice = create(:practice, team: team)
    @old_practice = create(:practice_in_past, team: team)
    visit team_practices_path(@practice.team)
  end

  it 'creates a practice_session' do
    page.should have_content 'There are no confirmed players yet'
    first(:button, "I'm going").click
    page.should have_content "I'm not going"
    page.should have_content 'Confirmed players'
  end

  it 'deletes a practice_session' do
    first(:button, "I'm going").click
    page.should have_content 'Confirmed players'

    click_link "I'm not going"
    page.should have_content 'There are no confirmed players yet'
  end
end

