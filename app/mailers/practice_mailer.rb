class PracticeMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def practice_scheduled(practice)
    @practice = practice
    mail :to => practice.team.email_address, :subject => "[#{@practice.team.name}] New practice scheduled"
  end

  def practice_updated(practice, recent_changes)
    @practice = practice
    @recent_changes = recent_changes
    mail :to => practice.team.email_address, :subject => "[#{@practice.team.name}] Practice updated"
  end
end

