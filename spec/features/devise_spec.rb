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
    fill_in 'user_password',              :with => 'password'
    fill_in 'user_password_confirmation', :with => 'password'
    click_button 'Sign up'

    page.should have_selector '.alert.alert-success', :text => 'Welcome!'
    page.should have_content 'Dave Kroondyk'
  end

  it 'shows errors for invalid users' do
    click_link 'Sign up'
    click_button 'Sign up'

    page.should have_selector '.alert.alert-danger'
    page.should have_content "Email can't be blank"
  end

  it 'changes a user profile' do
    click_link 'Sign in'
    fill_in 'Email',    :with => 'john.doe@example.com'
    fill_in 'Password', :with => 'password'
    click_button 'Sign in'

    click_link 'John Doe'
    fill_in 'Phone number',     :with => '111-111-1111'
    fill_in 'Current password', :with => 'password'
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

    visit edit_user_password_url({:reset_password_token => extract_token_from_email(:reset_password)})
    fill_in 'user_password', :with => 'password2'
    fill_in 'user_password_confirmation', :with => 'password2'
    click_button 'Change my password'

    page.should have_selector '.alert.alert-success', :text => 'Your password was changed successfully'
  end

  it 'allows user to delete account with associated objects' do
    @team = create(:team)
    ActsAsTenant.with_tenant(@team) do
      @team.team_members.create(:user => @user, :role => 'captain')
      @match = create(:match)
    end
    login(@user)
    visit team_matches_path(@match.team)
    @match.match_availabilities.first.set_availability("yes")
    @match.match_availabilities.first.save

    click_link 'John Doe'
    click_link 'Cancel my account'

    page.should have_selector '.alert.alert-success', :text => 'Bye! Your account was successfully cancelled. We hope to see you again soon.'
  end
end

