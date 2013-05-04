require 'spec_helper'

describe 'matches' do
  before :each do
    login_captain
    @match = create(:match)
    @match.team.team_members.create(:user => @captain, :role => 'captain')
    visit team_matches_path(@match.team)
  end

  it 'displays the matchs' do
    page.should have_content 'June 26, 2014 at 11:00 am'
  end

  it 'creates a match' do
    click_link 'Add a match'
    fill_in 'What day?', :with => '6/27/2014'
    select  '07:00 PM',  :from => 'What time?'
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
    select  '06:00 PM',  :from => 'What time?'
    click_button 'Save match'

    page.should have_selector '.alert.alert-success', :text => 'Match updated'
    page.should have_content 'June 28, 2014 at 6:00 pm'
  end

  it 'deletes a match' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Match deleted'
    page.should_not have_content 'June 27, 2014 at 7:00 pm'
  end

  it 'notifies team members' do
    within('.match-actions') { click_link 'Notify team' }
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
    fill_in 'Location', :with => @match.location
    fill_in 'Comment', :with => @match.comment
    click_button 'Save match'
    page.should have_selector '.disabled', :text => 'Notify team'

    # sends updated email after match is updated
    click_link 'Edit'
    fill_in 'What day?', :with => '6/25/2014'
    select  '06:00 PM',  :from => 'What time?'
    click_button 'Save match'
    page.should_not have_selector '.disabled', :text => 'Notify team'
    within('.match-actions') { click_link 'Notify team' }
    last_email.subject.should == "[#{@match.team.name}] Match updated"
    page.should have_selector '.disabled', :text => 'Notify team'
  end
end

