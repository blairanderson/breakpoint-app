require 'spec_helper'

describe 'practices' do
  before :each do
    login_admin
    @practice = create(:practice)
    visit season_path(@practice.season)
  end

  it 'displays the practices' do
    page.should have_content 'June 23, 2014 11:00 am'
  end

  it 'creates a practice' do
    click_link 'Add a practice'
    fill_in 'When?', :with => 'June 24, 2014 at 7pm'
    click_button 'Create Practice'

    ActionMailer::Base.deliveries.should_not be_empty
    page.should have_selector '.alert.alert-success', :text => 'Practice created'
    page.should have_content 'June 24, 2014 7:00 pm'
  end

  it 'shows errors for invalid practices' do
    click_link 'Add a practice'
    click_button 'Create Practice'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "Date string can't be blank"
  end

  it 'edits a practice' do
    click_link 'Edit'
    fill_in 'When?', :with => 'June 25, 2014 at 6pm'
    click_button 'Update Practice'

    ActionMailer::Base.deliveries.should_not be_empty
    page.should have_selector '.alert.alert-success', :text => 'Practice updated'
    page.should have_content 'June 25, 2014 6:00 pm'
  end

  it 'deletes a practice' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Practice deleted'
    page.should_not have_content 'June 24, 2014 7:00 pm'
  end
end