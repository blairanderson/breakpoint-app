class InviteMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'

  def new_user_invitation(options)
    @invite = Invite.find(options.fetch(:invite_id))
    @token = @invite.user.reset_password_token!
    @invite_title = "[#{@invite.team.name}] #{@invite.invited_by.name} invited you to the team"
    mail :to    => @invite.user.email,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => @invite_title
  end

  def invitation(options)
    @invite = Invite.find(options.fetch(:invite_id))
    @invite_title = "[#{@invite.team.name}] #{@invite.invited_by.name} invited you to the team"
    mail :to    => @invite.user.email,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => @invite_title
  end
end

