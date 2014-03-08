class PracticeMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'
  helper MailerHelper

  def practice_scheduled(practice, to, options)
    @team_name = practice.team.name
    @mail_type = "Practice"
    @practice  = practice
    @user_id   = options.fetch(:user_id)
    @from      = options.fetch(:from)
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@practice.team.name}] New practice scheduled"
  end

  def practice_updated(practice, to, options)
    @team_name      = practice.team.name
    @mail_type = "Practice"
    @practice       = practice
    @user_id        = options[:user_id]
    @from           = options.fetch(:from)
    @recent_changes = options.fetch(:recent_changes)
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@practice.team.name}] Practice updated"
  end
end

