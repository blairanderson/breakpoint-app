require "spec_helper"

describe PracticeMailer do
  before :each do
    @user = create(:user)
    @user2 = create(:user2)
    @team = create(:team, :users => [@user, @user2])
    ActsAsTenant.current_tenant = @team
    @practice = create(:practice)
  end

  after :each do
    ActsAsTenant.current_tenant = nil
  end

  it 'sends practice scheduled email' do
    options = {
      from: @user.name,
      reply_to: @user.email,
      user_id: @user2.id
    }

    PracticeMailer.practice_scheduled(@practice, @user2.email, options).deliver

    last_email.should_not be_nil
    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should eq "[#{@practice.team.name}] New practice scheduled"
    last_email.encoded.should match /<h1>New practice scheduled for/
  end

  it 'sends practice updated email', :versioning => true do
    options = {
      from: @user.name,
      reply_to: @user.email,
      user_id: @user2.id,
      recent_changes: []
    }

    PracticeMailer.practice_updated(@practice, @user2.email, options).deliver

    last_email.should_not be_nil
    last_email.to.should =~ ['dave.kroondyk@example.com']
    last_email.subject.should eq "[#{@practice.team.name}] Practice updated"
    last_email.encoded.should match /<h1>Practice scheduled for/
  end
end

