require 'spec_helper'

describe 'matches' do
  before :each do
    login_captain
    ActsAsTenant.current_tenant = create(:team)
    ActsAsTenant.current_tenant.team_members.create(:user => @captain, :role => 'captain')
    @match = create(:match)
    ActsAsTenant.current_tenant = nil
    visit team_matches_path(@match.team)
  end

  it 'displays the matches' do
    page.should have_content 'June 26, 2014 at 11:00 am'
  end

  it 'shows notification, lineup, and edit match only to captains' do
    page.should have_content 'Notification'
    page.should have_content 'Lineup'
    page.should have_content 'Edit'
    page.should have_content 'Delete'
    @captain.team_members.where(:team => @match.team).first.update_attributes(:role => 'member')
    visit team_matches_path(@match.team)
    page.should_not have_content 'Notification'
    page.should_not have_content 'Lineup'
    page.should_not have_button 'Edit'
    page.should_not have_content 'Delete'
  end

  it 'creates a match' do
    click_link 'Add a match'
    fill_in 'What day?', :with => '6/27/2014'
    fill_in 'What time?', :with => '07:00 PM'
    fill_in 'Opponent',  :with => 'Paxton'
    fill_in 'Location',  :with => 'PaxtonBigClub'
    click_button 'Save match'

    page.should have_selector '.alert.alert-success', :text => 'Match created'
    page.should have_content 'June 27, 2014 at 7:00 pm'
    page.should have_content 'PaxtonBigClub'
  end

  it 'shows errors for invalid matchs' do
    click_link 'Add a match'
    fill_in 'What day?', :with => ''
    click_button 'Save match'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "Date string can't be blank"
  end

  it 'edits a match' do
    click_link 'Edit'
    fill_in 'What day?', :with => '6/28/2014'
    fill_in 'What time?', :with => '06:00 PM'
    click_button 'Save match'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    page.should have_content 'June 28, 2014 at 6:00 pm'
  end

  it 'deletes a match' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Match deleted'
    page.should_not have_content 'June 27, 2014 at 7:00 pm'
  end

  it 'notifies team members', :versioning => true do
    click_link 'Notify team'
    page.should have_selector '.alert.alert-success', :text => 'Notification email sent to team'
    last_email.subject.should == "[#{@match.team.name}] New match scheduled"
    page.should have_selector '.disabled', :text => 'Notify team'

    # stays disabled if nothing in the match changed
    click_link 'Edit'
    # there is some weird thing going on here with capybara and the \n in text areas
    # https://github.com/jnicklas/capybara/issues/677 says it was fixed, but I'm getting
    # a \n stored at the beginning of the comment field, which the "browser" should ignore.
    # If I manually fill in the comment field with the same value from factory_girl,
    # it works fine.
    fill_in 'Opponent', :with => @match.opponent
    fill_in 'Location', :with => @match.location
    fill_in 'Comment', :with => @match.comment
    click_button 'Save match'
    page.should have_selector '.disabled', :text => 'Notify team'

    # sends updated email after match is updated
    click_link 'Edit'
    fill_in 'What day?', :with => '6/25/2014'
    fill_in 'What time?', :with => '06:00 PM'
    click_button 'Save match'
    page.should_not have_selector '.disabled', :text => 'Notify team'
    click_link 'Notify team'
    last_email.subject.should == "[#{@match.team.name}] Match updated"
    page.should have_selector '.disabled', :text => 'Notify team'
  end
end

