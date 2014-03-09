class Match < ActiveRecord::Base
  class MatchAvailabilityTokenExpired < StandardError; end

  NOTIFIED_LINEUP_STATES = %w[lineup_created lineup_updated notified_team_lineup]

  include DateTimeParser
  include NotifyStateMachine

  has_many :match_availabilities, -> { joins(user: :active_teams).where('"teams"."id" = "match_availabilities"."team_id"') }, :dependent => :destroy
  has_many :match_lineups,        -> { order(:ordinal) }, :dependent => :destroy

  validates :team, presence: true

  accepts_nested_attributes_for :match_lineups

  after_create :setup_match_lineups

  delegate :lineup_created?, :lineup_updated?, :notified_team_lineup?, :to => :notified_team_lineup_state

  acts_as_tenant :team
  has_paper_trail :ignore => [:notified_state, :notified_lineup_state, :updated_at]

  def self.notify(name, options)
    match = find(options.fetch(:match_id))

    match.team_users(options.fetch(:reply_to)).each do |to|
      MatchMailer.send("match_#{name}", match, to.email, options.merge(user_id: to.id)).deliver
    end
  end

  def self.match_availability_from_token(token)
    match_id, user_id, timestamp = Rails.application.message_verifier("match-email-response").verify(token)

    if timestamp < 7.days.ago
      raise MatchAvailabilityTokenExpired
    end

    find(match_id).match_availability_for(user_id)
  end

  def team_emails(from = nil)
    team.team_emails.reject { |e| from == e }
  end

  def team_users(from = nil)
    team.active_users.reject { |user| from == user.email }
  end

  def team_location
    home_team? ? 'Home' : 'Away'
  end

  def match_availability_for(user_id)
    match_availabilities.where(user_id: user_id).first_or_initialize
  end

  def match_availability_token_for(user_id)
    Rails.application.message_verifier("match-email-response").generate([id, user_id, Time.now])
  end

  def available_players
    match_availabilities.includes(:user).where(:available => true).collect(&:user)
  end

  def unavailable_players
    match_availabilities.includes(:user).where(:available => false).collect(&:user)
  end

  def players_status
    available_player_list = available_players
    unavailable_player_list = unavailable_players
    noresponse_player_list = (team.new_and_active_users) - available_player_list - unavailable_player_list

    players_status = {
                      "Available" => available_player_list,
                      "Unavailable" => unavailable_player_list,
                      "No Response" => noresponse_player_list
                      }

    players_status
  end

  def recent_changes
    versions.last.changeset
  end

  def lineup_changed?
    match_lineups.flat_map(&:match_players).map(&:previous_changes).reject { |change| change.blank? }.present?
  end

  def notified_team_lineup_state
    (notified_lineup_state || NOTIFIED_LINEUP_STATES.first).inquiry
  end

  def reset_notified_lineup!
    update_attributes!(:notified_lineup_state => 'lineup_updated') if notified_team_lineup?
  end

  def notified_lineup!
    update_attributes!(:notified_lineup_state => 'notified_team_lineup') if lineup_created? || lineup_updated?
  end

  def has_results?
    match_lineups.collect { |l| l.has_results? }.any?
  end

  def won?
    matches_won > matches_lost
  end

  def matches_won
    result[true]
  end

  def matches_lost
    result[false]
  end

  private
  def setup_match_lineups
    ordinal = 0
    1.upto(team.singles_matches) do |singles_match|
      lineup = match_lineups.create :match_type => "##{singles_match} Singles", :ordinal => ordinal
      lineup.match_players.create
      1.upto(3) { |i| lineup.match_sets.create(:ordinal => i) }
      ordinal += 1
    end

    1.upto(team.doubles_matches) do |doubles_match|
      lineup = match_lineups.create :match_type => "##{doubles_match} Doubles", :ordinal => ordinal
      2.times { lineup.match_players.create }
      1.upto(3) { |i| lineup.match_sets.create(:ordinal => i) }
      ordinal += 1
    end
  end

  def result
    @result ||= match_lineups.collect { |l| l.won? }.inject(Hash.new(0)) { |h,i| h[i] += 1; h }
  end
end

# TODO
# Split Format (enable second time option - for double?)

# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  location       :text             default(""), not null
#  team_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#  home_team      :boolean          default(TRUE)
#  comment        :text
#

