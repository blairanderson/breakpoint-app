class MatchMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def match_scheduled(match)
    @match = match
    mail :to => match.team.email_address, :subject => "[#{@match.team.name}] New match scheduled"
  end

  def match_updated(match, recent_changes)
    @match = match
    @recent_changes = recent_changes
    mail :to => match.team.email_address, :subject => "[#{@match.team.name}] Match updated"
  end
end

