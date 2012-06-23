require 'spec_helper'

describe 'users' do
  before :each do
    @user = create(:user)
    visit users_path
  end

  it 'displays the users' do
    page.should have_selector '.page-header', :text => 'Users'
    page.should have_content 'John Doe'
  end

  it 'creates a user' do
    click_link 'New user'
    fill_in 'First name',   :with => 'Dave'
    fill_in 'Last name',    :with => 'Kroondyk'
    fill_in 'Email',        :with => 'davekaro@gmail.com'
    fill_in 'Phone number', :with => '555-555-5555'
    click_button 'Create User'

    page.should have_selector '.alert.alert-success', :text => 'User created'
    page.should have_content 'Dave Kroondyk'
  end

  it 'shows errors for invalid users' do
    click_link 'New user'
    click_button 'Create User'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "First name can't be blank"
  end

  it 'edits a user' do
    click_link 'Edit'
    fill_in 'Last name', :with => 'Smith'
    click_button 'Update User'

    page.should have_selector '.alert.alert-success', :text => 'User updated'
    page.should have_content 'John Smith'
    page.should_not have_content 'John Doe'
  end

  it 'deletes a user' do
    click_link 'Delete'

    page.should have_selector '.alert.alert-success', :text => 'User deleted'
    page.should_not have_content 'John Doe'
  end
end