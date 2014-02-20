class MatchMailer < ActionMailer::Base
  layout 'mailer'
  helper MailerHelper

  def match_scheduled(to, from, reply_to, match)
    @match = match
    mail :to => to,
      :from => "#{from} <#{ActionMailer::Base.default[:from]}>",
      :reply_to => reply_to,
      :subject => "[#{@match.team.name}] New match scheduled"
  end

  def match_updated(to, from, reply_to, match, recent_changes)
    @match = match
    @recent_changes = recent_changes
    mail :to => to,
      :from => "#{from} <#{ActionMailer::Base.default[:from]}>",
      :reply_to => reply_to,
      :subject => "[#{@match.team.name}] Match updated"
  end
end

