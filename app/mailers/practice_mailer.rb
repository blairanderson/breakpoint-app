class PracticeMailer < ActionMailer::Base
  layout 'mailer'

  def practice_scheduled practice
    @practice = practice
    mail :to => practice.team_emails, :subject => 'New practice scheduled'
  end

  def practice_updated practice
    @practice = practice
    mail :to => practice.team_emails, :subject => 'Practice updated'
  end
end
