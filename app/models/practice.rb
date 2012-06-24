class Practice < ActiveRecord::Base
  include ChronicParser

  has_many :practice_sessions, :dependent => :destroy
  has_many :users, :through => :practice_sessions
  belongs_to :season

  attr_accessible :comment

  validates_presence_of :season
end
