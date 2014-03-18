class MatchMailer < ActionMailer::Base
  include MailerHelper

  layout 'mailer'
  helper MailerHelper

  def created(match, to, options)
    @team_name    = match.team.name
    @match        = match
    @user_id      = options[:user_id]
    availability  = match.match_availability_for(@user_id)
    @availability = availability.new_record? ? nil : availability
    @token        = match.match_availability_token_for(@user_id)
    @comments     = options[:comments]
    @from         = options.fetch(:from)
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => options.fetch(:subject)
  end

  def updated(match, to, options)
    @team_name      = match.team.name
    @match          = match
    @user_id        = options[:user_id]
    availability    = match.match_availability_for(@user_id)
    @availability   = availability.new_record? ? nil : availability
    @token          = match.match_availability_token_for(@user_id)
    @comments       = options[:comments]
    @from           = options.fetch(:from)
    @recent_changes = options[:recent_changes]
    mail :to    => to,
      :from     => formatted_from(@from),
      :reply_to => options.fetch(:reply_to),
      :subject  => options.fetch(:subject)
  end

  def match_scheduled(match, to, options)
    @mail_type = "Match"
    created(match, to, options.merge(subject: "[#{match.team.name}] Match on #{l match.date, :format => :long}"))
  end

  def match_updated(match, to, options)
    @mail_type = "Match"
    updated(match, to, options.merge(subject: "[#{match.team.name}] Update for match on #{l match.date, :format => :long}"))
  end

  def match_player_request(match, to, options)
    @mail_type = "Need players"
    created(match, to, options.merge(subject: "[#{match.team.name}] Need players for match on #{l match.date, :format => :long}"))
  end

  def match_lineup_set(match, to, options)
    @mail_type = "Lineup"
    created(match, to, options.merge(subject: "[#{match.team.name}] Lineup for match on #{l match.date, :format => :long}"))
    attachement(match, options.fetch(:from))
  end

  def match_lineup_updated(match, to, options)
    @mail_type = "Lineup"
    updated(match, to, options.merge(subject: "[#{match.team.name}] Lineup updated for match on #{l match.date, :format => :long}"))
    attachement(match, options.fetch(:from))
  end

  def attachement(match, from_name)
    attachments["Match.ics"] = 
    {
      mime_type: "text/calendar",
      content:   build_ics(match, from_name) 
    }
  end
end

