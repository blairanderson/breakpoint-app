class MatchMailer < ActionMailer::Base
  include MailerHelper

  layout 'team_mailer'
  helper MailerHelper

  def created(match, to, options)
    @team_name = match.team.name
    @match     = match
    @user_id   = options[:user_id]
    @comments  = options[:comments]
    @from      = options.fetch(:from)
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => options.fetch(:subject)
  end

  def updated(match, to, options)
    @team_name = match.team.name
    @match     = match
    @user_id   = options[:user_id]
    @comments  = options[:comments]
    @from      = options.fetch(:from)
    @recent_changes = options[:recent_changes]
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => options.fetch(:subject)
  end

  def match_scheduled(match, to, options)
    @mail_type = "Match"
    created(match, to, options.merge(subject: "[#{match.team.name}] New match scheduled"))
  end

  def match_updated(match, to, options)
    @mail_type = "Match"
    updated(match, to, options.merge(subject: "[#{match.team.name}] Match updated"))
  end

  def match_lineup_set(match, to, options)
    @mail_type = "Lineup"
    created(match, to, options.merge(subject: "[#{match.team.name}] Lineup set for match on #{l match.date}"))
  end

  def match_lineup_updated(match, to, options)
    @mail_type = "Lineup"
    updated(match, to, options.merge(subject: "[#{match.team.name}] Lineup updated for match on #{l match.date}"))
  end
end

