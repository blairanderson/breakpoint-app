class Season < ActiveRecord::Base
  include ChronicParser

  has_many :practices, :dependent => :destroy
  has_many :matches,   :dependent => :destroy
  has_many :players,   :dependent => :destroy
  has_many :users,     :through   => :players
  
  attr_accessible :name

  validates_presence_of :name

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
