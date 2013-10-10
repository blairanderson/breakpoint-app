class MatchLineupMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def lineup_set(team_id, match_id)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @match = Match.find(match_id)
      mail :to => @match.team.email_address, :subject => "[#{@match.team.name}] Lineup set for match on #{l @match.date}"
    end
  end

  def lineup_updated(team_id, match_id, recent_changes)
    ActsAsTenant.with_tenant(Team.find(team_id)) do
      @match = Match.find(match_id)
      @recent_changes = recent_changes
      mail :to => @match.team.email_address, :subject => "[#{@match.team.name}] Lineup updated for match on #{l @match.date}"
    end
  end
end

