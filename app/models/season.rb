class Season < ActiveRecord::Base
  include ChronicParser

  has_many :practices, :dependent => :destroy
  has_many :matches,   :dependent => :destroy
  has_many :players,   :dependent => :destroy
  has_many :users,     :through   => :players
  
  attr_accessible :name, :singles_matches, :doubles_matches

  validates_presence_of :name, :singles_matches, :doubles_matches

  def self.newest
    order('date desc')
  end

  def upcoming_practices
    practices.where('date > ?', Time.now).order('date asc')
  end

  def upcoming_matches
    matches.where('date > ?', Time.now).order('date asc')
  end
end

# TODO
# Club/Facility
# Team Name
# Team Type
#  Adult
#  Mixed
#  Senior
#  Senior 65
#  Senior 60
#  Fifty Mixed
#  Combo
#  Juniors
#  HighSchool
#  College
#  Other
# Level
#  2.5
#  3.0
#  3.5
#  4.0
#  4.5
#  5.0
#  5.5
#  6.0
#  6.5
#  7.0
#  7.5
#  8.0
#  8.5
#  9.0
#  9.5
#  Open
#  Juniors
#  HighSchool
#  College
#  Other
# Singles Matches 0-9
# Doubels Matches 0-9
# Alternates 0-9 (???)

# == Schema Information
#
# Table name: seasons
#
#  created_at      :datetime         not null
#  date            :datetime         not null
#  doubles_matches :integer          not null
#  id              :integer          not null, primary key
#  name            :string(255)      default(""), not null
#  singles_matches :integer          not null
#  updated_at      :datetime         not null
#

