class InviteMailer < ActionMailer::Base
  layout 'mailer'

  def new_user_invitation(invite)
    @invite = invite
    @invite_title = "#{@invite.invited_by.name} invited you to the team, #{@invite.team.name}"
    mail :to => invite.user.email, :subject => @invite_title
  end

  def invitation(invite)
    @invite = invite
    @invite_title = "#{@invite.invited_by.name} invited you to the team, #{@invite.team.name}"
    mail :to => invite.user.email, :subject => @invite_title
  end
end

