class MatchMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def match_scheduled(team_id, match_id)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @match = Match.find(match_id)
      mail :to => @match.team.email_address, :subject => "[#{@match.team.name}] New match scheduled"
    end
  end

  def match_updated(team_id, match_id, recent_changes)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @match = Match.find(match_id)
      @recent_changes = recent_changes
      mail :to => @match.team.email_address, :subject => "[#{@match.team.name}] Match updated"
    end
  end
end

