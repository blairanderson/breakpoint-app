require 'spec_helper'

describe 'seasons' do
  before :each do
    season = create(:season)
    visit seasons_path
  end

  it 'displays the seasons' do
    page.should have_selector '.page-header', :text => 'Seasons'
    page.should have_content '2012 Summer'
  end

  it 'creates a season' do
    click_link 'New season'
    fill_in 'Name', :with => '2013 Summer'
    click_button 'Create Season'

    page.should have_selector '.alert.alert-success', :text => 'Season created'
    page.should have_content '2013 Summer'
  end

  it 'shows errors for invalid seasons' do
    click_link 'New season'
    click_button 'Create Season'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "Name can't be blank"
  end

  it 'edits a season' do
    click_link 'Edit'
    fill_in 'Name', :with => '2010 Summer'
    click_button 'Update Season'

    page.should have_selector '.alert.alert-success', :text => 'Season updated'
    page.should have_content '2010 Summer'
  end

  it 'deletes a season' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'Season deleted'
    page.should_not have_content '2012 Summer'
  end
end