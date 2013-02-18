class Match < ActiveRecord::Base
  LOCATIONS = %w[home away]
  include ChronicParser
  include NotifyStateMachine

  has_many   :match_availabilities, :dependent => :destroy
  has_many   :match_lineups,        :dependent => :destroy, :order => :ordinal
  has_many   :users,                :through   => :match_availabilities
  belongs_to :season

  attr_accessible :location, :opponent, :match_lineups_attributes, :notified_state

  validates_presence_of :season, :location, :opponent

  accepts_nested_attributes_for :match_lineups

  after_create :setup_match_lineups

  def home?
    location == 'home'
  end

  def away?
    location == 'away'
  end

  def team_emails
    season.team_emails
  end

  def match_availability_for_user(user_id)
    match_availabilities.where(user_id: user_id).first
  end

  private
  def setup_match_lineups
    ordinal = 0
    1.upto(season.singles_matches) do |singles_match|
      match_lineups.create :match_type => "##{singles_match} Singles", :ordinal => ordinal
      ordinal += 1
    end

    1.upto(season.doubles_matches) do |doubles_match|
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
#  created_at :datetime         not null
#  date       :datetime         not null
#  id         :integer          not null, primary key
#  location   :string(255)      default(""), not null
#  opponent   :string(255)      default(""), not null
#  season_id  :integer
#  updated_at :datetime         not null
#

