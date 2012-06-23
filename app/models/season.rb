class Season < ActiveRecord::Base
  attr_accessible :name

  has_many :players
  has_many :users, :through => :players

  validates_presence_of :name
end
