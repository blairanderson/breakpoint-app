# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.include FactoryGirl::Syntax::Methods

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
end

def login_admin
  @admin = create(:admin)
  visit new_user_session_path
  fill_in 'Email',    :with => 'admin@example.com'
  fill_in 'Password', :with => 'testing'
  click_button 'Sign in'
end

def login_captain
  @captain = create(:captain)
  visit new_user_session_path
  fill_in 'Email',    :with => 'captain@example.com'
  fill_in 'Password', :with => 'testing'
  click_button 'Sign in'
end

def login_team_member
  @team_member = create(:team_member)
  visit new_user_session_path
  fill_in 'Email',    :with => 'team_member@example.com'
  fill_in 'Password', :with => 'testing'
  click_button 'Sign in'
end

