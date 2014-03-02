class MatchMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'
  helper MailerHelper

  def created(match, to, options)
    @match = match
    @comments = options[:comments]
    mail :to    => to,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => options.fetch(:subject)
  end

  def updated(match, to, options)
    @match = match
    @comments = options[:comments]
    @recent_changes = options[:recent_changes]
    mail :to    => to,
      :from     => formatted_from(options.fetch(:from)),
      :reply_to => options.fetch(:reply_to),
      :subject  => options.fetch(:subject)
  end

  def match_scheduled(match, to, options)
    created(match, to, options.merge(subject: "[#{match.team.name}] New match scheduled"))
  end

  def match_updated(match, to, options)
    updated(match, to, options.merge(subject: "[#{match.team.name}] Match updated"))
  end

  def match_lineup_set(match, to, options)
    created(match, to, options.merge(subject: "[#{match.team.name}] Lineup set for match on #{l match.date}"))
  end

  def match_lineup_updated(match, to, options)
    updated(match, to, options.merge(subject: "[#{match.team.name}] Lineup updated for match on #{l match.date}"))
  end
end

