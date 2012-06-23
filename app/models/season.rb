class Season < ActiveRecord::Base
  has_many :practices
  has_many :players
  has_many :users, :through => :players
  
  attr_accessible :name

  validates_presence_of :name
end
