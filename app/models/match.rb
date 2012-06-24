class Match < ActiveRecord::Base
  LOCATIONS = %w[home away]
  include ChronicParser

  has_many   :match_availabilities, :dependent => :destroy
  has_many   :users,                :through   => :match_availabilities
  belongs_to :season

  attr_accessible :location, :opponent

  validates_presence_of :season, :location, :opponent

  def home?
    location == 'home'
  end

  def away?
    location == 'away'
  end
end
