class MatchMailer < ActionMailer::Base
  layout 'mailer'

  def match_scheduled match
    @match = match
    mail :to => match.team_emails, :subject => 'New match scheduled'
  end

  def match_updated match
    @match = match
    mail :to => match.team_emails, :subject => 'Match updated'
  end
end