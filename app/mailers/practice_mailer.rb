class PracticeMailer < ActionMailer::Base
  layout 'mailer'

  def practice_scheduled(practice)
    @practice = practice
    mail :to => practice.team_emails, :subject => 'New practice scheduled'
  end

  def practice_updated(practice, recent_changes)
    @practice = practice
    @recent_changes = recent_changes
    mail :to => practice.team_emails, :subject => 'Practice updated'
  end
end

