require 'spec_helper'

describe 'devise' do
  before :each do
    @user = create(:user)
    visit root_path
  end

  it 'signs a user up' do
    click_link 'Sign up'
    fill_in 'First name',                 :with => 'Dave'
    fill_in 'Last name',                  :with => 'Kroondyk'
    fill_in 'Email',                      :with => 'davekaro@gmail.com'
    fill_in 'Phone number',               :with => '555-555-5555'
    fill_in 'user_password',              :with => 'testing'
    fill_in 'user_password_confirmation', :with => 'testing'
    click_button 'Sign up'

    page.should have_selector '.alert.alert-success', :text => 'Welcome!'
    page.should have_content 'Dave Kroondyk'
  end

  it 'shows errors for invalid users' do
    click_link 'Sign up'
    click_button 'Sign up'

    page.should have_selector '.alert.alert-block.alert-error'
    page.should have_content "Email can't be blank"
  end

  it 'changes a user profile' do
    click_link 'Sign in'
    fill_in 'Email',    :with => 'john.doe@example.com'
    fill_in 'Password', :with => 'testing'
    click_button 'Sign in'

    click_link 'John Doe'
    fill_in 'Phone number',     :with => '111-111-1111'
    fill_in 'Current password', :with => 'testing'
    click_button 'Update'

    page.should have_selector '.alert.alert-success', :text => 'You updated your account successfully.'
  end

  it 'allows forgot password' do
    click_link 'Sign in'
    click_link 'Forgot your password?'
    fill_in 'Email', :with => 'john.doe@example.com'
    click_button 'Send me reset password instructions'

    last_email.should_not be_nil
    last_email.to.should == ['john.doe@example.com']

    visit edit_user_password_url({:reset_password_token => User.find_by_email('john.doe@example.com').reset_password_token})
    fill_in 'user_password', :with => 'testing2'
    fill_in 'user_password_confirmation', :with => 'testing2'
    click_button 'Change my password'

    page.should have_selector '.alert.alert-success', :text => 'Your password was changed successfully'
  end
end

