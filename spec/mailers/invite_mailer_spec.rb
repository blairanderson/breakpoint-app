require "spec_helper"

describe InviteMailer do
  before :each do
    @user = create(:user)
    user2 = create(:user2)
    @team = create(:team, :users => [@user])
    @invite = create(:invite, :user => user2, :invited_by => @user, :team => @team)
  end

  it 'sends new user invitation email' do
    email = InviteMailer.new_user_invitation(@team.id, @invite.id).deliver

    last_email.should_not be_nil
    email.to.should eq ['dave.kroondyk@example.com']
    email.subject.should eq "[#{@team.name}] #{@user.name} invited you to the team"
    email.encoded.should match /<h1>Please join your team on Breakpoint App/
  end

  it 'sends invitation email' do
    email = InviteMailer.invitation(@team.id, @invite.id).deliver

    last_email.should_not be_nil
    email.to.should eq ['dave.kroondyk@example.com']
    email.subject.should eq "[#{@team.name}] #{@user.name} invited you to the team"
    email.encoded.should match /Please accept your invitation/
  end
end

