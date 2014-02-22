class MatchMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'
  helper MailerHelper

  def match_scheduled(match, to, options)
    @match = match
    mail :to    => to,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@match.team.name}] New match scheduled"
  end

  def match_updated(match, to, options)
    @match = match
    @recent_changes = options.fetch(:recent_changes)
    mail :to    => to,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => "[#{@match.team.name}] Match updated"
  end
end

