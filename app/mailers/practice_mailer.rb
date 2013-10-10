class PracticeMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def practice_scheduled(team_id, practice_id)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @practice = Practice.find(practice_id)
      mail :to => @practice.team.email_address, :subject => "[#{@practice.team.name}] New practice scheduled"
    end
  end

  def practice_updated(team_id, practice_id, recent_changes)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @practice = Practice.find(practice_id)
      @recent_changes = recent_changes
      mail :to => @practice.team.email_address, :subject => "[#{@practice.team.name}] Practice updated"
    end
  end
end

