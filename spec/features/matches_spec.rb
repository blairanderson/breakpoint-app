require 'spec_helper'

describe 'matches' do
  before :each do
    login_captain
    @match = create(:match)
    @old_match = create(:match_in_past)
    visit team_matches_path(@match.team)
  end

  it 'displays the matchs' do
    page.should have_content 'June 26, 2014 11:00 am'
  end

  it 'creates a match' do
    click_link 'Add a match'
    fill_in 'When?',    :with => 'June 27, 2014 at 7pm'
    select  'Home',     :from => 'Location'
    fill_in 'Opponent', :with => 'Paxton'
    click_button 'Save match'

    page.should have_selector '.alert.alert-success', :text => 'Match created'
    page.should have_content 'June 27, 2014 7:00 pm'
  end

  it 'shows errors for invalid matchs' do
    click_link 'Add a match'
    click_button 'Save match'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "Date string can't be blank"
  end

  it 'edits a match' do
    click_link 'Edit'
    fill_in 'When?', :with => 'June 28, 2014 at 6pm'
    click_button 'Save match'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    page.should have_content 'June 28, 2014 6:00 pm'
  end

  it 'deletes a match' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Match deleted'
    page.should_not have_content 'June 27, 2014 7:00 pm'
  end

  it 'notifies team members' do
    click_link 'Notify team'
    page.should have_selector '.alert.alert-success', :text => 'Notification email sent to team'
    last_email.subject.should == 'New match scheduled'
    page.should have_selector '.disabled', :text => 'Notify team'

    # stays disabled if nothing in the match changed
    click_link 'Edit'
    click_button 'Save match'
    page.should have_selector '.disabled', :text => 'Notify team'

    # sends updated email after match is updated
    click_link 'Edit'
    fill_in 'When?', :with => 'June 25, 2014 at 6pm'
    click_button 'Save match'
    page.should_not have_selector '.disabled', :text => 'Notify team'
    click_link 'Notify team'
    last_email.subject.should == 'Match updated'
    page.should have_selector '.disabled', :text => 'Notify team'
  end
end
