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
    last_email.subject.should == "[2012 Summer] Practice on #{I18n.l @practice.date, :format => :long}"
    last_email.encoded.should match /When:/
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
    last_email.subject.should == "[2012 Summer] Practice on #{I18n.l @practice.date, :format => :long} updated"
    last_email.encoded.should match /When:/
  end
end

