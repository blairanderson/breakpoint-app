class Match < ActiveRecord::Base
  LOCATIONS = %w[home away]
  include ChronicParser
  include NotifyStateMachine

  has_many   :match_availabilities, :dependent => :destroy
  has_many   :match_lineups,        :dependent => :destroy, :order => :ordinal
  has_many   :players,              :through   => :match_availabilities, :source => :user
  belongs_to :team

  validates_presence_of :team, :location, :opponent

  accepts_nested_attributes_for :match_lineups

  after_create :setup_match_lineups

  def home?
    location == 'home'
  end

  def away?
    location == 'away'
  end

  def team_emails
    team.team_emails
  end

  def match_availability_for_user(user_id)
    match_availabilities.where(user_id: user_id).first
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
#  location       :string(255)      default(""), not null
#  opponent       :string(255)      default(""), not null
#  team_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#

