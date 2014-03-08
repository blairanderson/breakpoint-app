class WelcomeMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'

  def new_user_welcome(options)
    @team_member = TeamMember.find(options.fetch(:team_member_id))
    @token = @team_member.user.reset_password_token!
    welcome_email(options)
  end

  def welcome(options)
    @team_member = TeamMember.find(options.fetch(:team_member_id))
    welcome_email(options)
  end

  def welcome_email(options)
    @team_name     = @team_member.team.name
    @mail_type     = "Welcome"
    @from          = options.fetch(:from)
    mail :to    => @team_member.user.email,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@team_name}] #{@from} added you to the team"
  end
end

