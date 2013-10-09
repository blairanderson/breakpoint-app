require 'spec_helper'

describe 'practice_sessions' do
  before :each do
    login_captain
    ActsAsTenant.current_tenant = create(:team)
    ActsAsTenant.current_tenant.team_members.create(:user => @captain, :role => 'captain')
    @practice = create(:practice)
    @old_practice = create(:practice_in_past)
    ActsAsTenant.current_tenant = nil
    visit team_practices_path(@practice.team)
  end

  it 'checks empty practice_session' do
    page.should have_content 'There are no confirmed players yet'
  end

  it 'creates a practice_session as available' do
    first(:button, "I can play").click
    page.should have_content 'You can play'
  end

  it 'creates a practice_session as not available' do
    first(:button, "I can't play").click
    page.should have_content "You can't play"
  end

  it 'toggles practice_session' do
    first(:button, "I can play").click
    page.should have_content 'You can play'

    first(:button, "I can't play").click
    page.should have_content "You can't play"
  end

end

