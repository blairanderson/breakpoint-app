class Practice < ActiveRecord::Base
  include ChronicParser

  belongs_to :season

  attr_accessible :comment

  validates_presence_of :season
end
