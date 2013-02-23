require "spec_helper"

describe PracticeMailer do
  before :each do
    user = create(:user)
    user2 = create(:user2)
    team = create(:team, :users => [user, user2]) 
    @practice = create(:practice, :team => team)
  end

  it 'sends practice scheduled email' do
    email = PracticeMailer.practice_scheduled(@practice).deliver
    
    last_email.should_not be_nil
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should eq 'New practice scheduled'
    email.encoded.should match /<h1>New practice scheduled for/
  end

  it 'sends practice updated email' do
    email = PracticeMailer.practice_updated(@practice).deliver

    last_email.should_not be_nil
    email.to.should eq ['john.doe@example.com', 'dave.kroondyk@example.com']
    email.subject.should eq 'Practice updated'
    email.encoded.should match /<h1>Practice scheduled for/
  end
end
