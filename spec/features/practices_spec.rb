require 'spec_helper'

describe 'practices' do
  before :each do
    login_captain
    @practice = create(:practice)
    visit team_practices_path(@practice.team)
  end

  it 'displays the practices' do
    page.should have_content 'June 23, 2014 at 11:00 am'
  end

  it 'creates a practice' do
    click_link 'Add a practice'
    fill_in 'What day?', :with => '6/24/2014'
    select  '07:00 PM',  :from => 'What time?'
    fill_in 'Location',  :with => 'Paxton'
    fill_in 'Comment',   :with => 'tonsofdetail'
    click_button 'Save practice'

    last_email.should be_nil
    page.should have_selector '.alert.alert-success', :text => 'Practice created'
    page.should have_content 'June 24, 2014 at 7:00 pm'
    page.should have_content 'Paxton'
  end

  it 'shows errors for invalid practices' do
    click_link 'Add a practice'
    fill_in 'What day?', :with => ''
    click_button 'Save practice'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "Date string can't be blank"
  end

  it 'edits a practice' do
    click_link 'Edit'
    fill_in 'What day?', :with => '6/25/2014'
    select  '06:00 PM',  :from => 'What time?'
    click_button 'Save practice'

    last_email.should be_nil
    page.should have_selector '.alert.alert-success', :text => 'Practice updated'
    page.should have_content 'June 25, 2014 at 6:00 pm'
  end

  it 'deletes a practice' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Practice deleted'
    page.should_not have_content 'June 24, 2014 at 7:00 pm'
  end

  it 'notifies team members' do
    click_link 'Notify team'
    page.should have_selector '.alert.alert-success', :text => 'Notification email sent to team'
    last_email.subject.should == 'New practice scheduled'
    page.should have_selector '.disabled', :text => 'Notify team'

    # stays disabled if nothing in the practice changed
    click_link 'Edit'
    # there is some weird thing going on here with capybara and the \n in text areas
    # https://github.com/jnicklas/capybara/issues/677 says it was fixed, but I'm getting
    # a \n stored at the beginning of the comment field, which the "browser" should ignore.
    # If I manually fill in the comment field with the same value from factory_girl,
    # it works fine.
    fill_in 'Location', :with => @practice.location
    fill_in 'Comment', :with => @practice.comment
    click_button 'Save practice'
    page.should have_selector '.disabled', :text => 'Notify team'

    # sends updated email after practice is updated
    click_link 'Edit'
    fill_in 'What day?', :with => '6/25/2014'
    select  '06:00 PM',  :from => 'What time?'
    click_button 'Save practice'
    page.should_not have_selector '.disabled', :text => 'Notify team'
    click_link 'Notify team'
    last_email.subject.should == 'Practice updated'
    page.should have_selector '.disabled', :text => 'Notify team'
  end
end

