require "spec_helper"

describe InviteMailer do
  before :each do
    @user = create(:user)
    user2 = create(:user2)
    @team = create(:team, :users => [@user])
    @invite = create(:invite, :user => user2, :invited_by => @user, :team => @team)
  end

  it 'sends new user invitation email' do
    options = {
      from:      @user.name,
      reply_to:  @user.email,
      invite_id: @invite.id
    }

    InviteMailer.new_user_invitation(options).deliver

    last_email.should_not be_nil
    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email[:from].formatted.should eq ['John Doe <notifications@breakpointapp.com>']
    last_email.subject.should eq "[#{@team.name}] #{@user.name} invited you to the team"
    last_email.encoded.should match /<h1>Please join your team on Breakpoint App/
  end

  it 'sends invitation email' do
    options = {
      from:      @user.name,
      reply_to:  @user.email,
      invite_id: @invite.id
    }

    InviteMailer.invitation(options).deliver

    last_email.should_not be_nil
    last_email.to.should eq ['dave.kroondyk@example.com']
    last_email.subject.should eq "[#{@team.name}] #{@user.name} invited you to the team"
    last_email.encoded.should match /Please accept your invitation/
  end
end

