class Match < ActiveRecord::Base
  NOTIFIED_LINEUP_STATES = %w[lineup_created lineup_updated notified_team_lineup]

  include DateTimeParser
  include NotifyStateMachine

  has_many   :match_availabilities, :dependent => :destroy
  has_many   :match_lineups,        :dependent => :destroy, :order => :ordinal
  has_many   :players,              :through   => :match_availabilities, :source => :user
  belongs_to :team

  validates_presence_of :team

  accepts_nested_attributes_for :match_lineups

  after_create :setup_match_lineups

  delegate :lineup_created?, :lineup_updated?, :notified_team_lineup?, :to => :notified_team_lineup_state

  has_paper_trail :ignore => [:notified_state, :notified_lineup_state]

  def team_location
    home_team? ? 'Home' : 'Away'
  end

  def team_emails
    team.team_emails
  end

  def match_availability_for_user(user_id)
    match_availabilities.where(user_id: user_id).first
  end

  def recent_changes
    versions.last.changeset
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

  private
  def setup_match_lineups
    ordinal = 0
    1.upto(team.singles_matches) do |singles_match|
      match_lineups.create :match_type => "##{singles_match} Singles", :ordinal => ordinal
      ordinal += 1
    end

    1.upto(team.doubles_matches) do |doubles_match|
      2.times do
        match_lineups.create :match_type => "##{doubles_match} Doubles", :ordinal => ordinal
      end
      ordinal += 1
    end
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

