class PracticeMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'
  helper MailerHelper

  def practice_scheduled(practice, to, options)
    @practice = practice
    @user_id  = options.fetch(:user_id)
    mail :to    => to,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@practice.team.name}] New practice scheduled"
  end

  def practice_updated(practice, to, options)
    @practice = practice
    @user_id  = options[:user_id]
    @recent_changes = options.fetch(:recent_changes)
    mail :to    => to,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@practice.team.name}] Practice updated"
  end
end

