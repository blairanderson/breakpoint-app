class InviteMailer < ActionMailer::Base
  layout 'mailer'

  def new_user_invitation(team_id, invite_id)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @invite = Invite.find(invite_id)
      @token = @invite.user.reset_password_token!
      @invite_title = "[#{@invite.team.name}] #{@invite.invited_by.name} invited you to the team"
      mail :to => @invite.user.email, :subject => @invite_title
    end
  end

  def invitation(team_id, invite_id)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @invite = Invite.find(invite_id)
      @invite_title = "[#{@invite.team.name}] #{@invite.invited_by.name} invited you to the team"
      mail :to => @invite.user.email, :subject => @invite_title
    end
  end
end

