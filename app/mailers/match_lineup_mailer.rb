class MatchLineupMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def lineup_set(match)
    @match = match
    mail :to => match.team.email_address, :subject => "[#{@match.team.name}] Lineup set for match on #{l match.date}"
  end

  def lineup_updated(match, recent_changes)
    @match = match
    @recent_changes = recent_changes
    mail :to => match.team.email_address, :subject => "[#{@match.team.name}] Lineup updated for match on #{l match.date}"
  end
end

