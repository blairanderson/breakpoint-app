class MatchSet < ActiveRecord::Base
  belongs_to :match

  validates :games_won,  :presence => true
  validates :games_lost, :presence => true
  validates :ordinal,    :presence => true
  validates :match,      :presence => true
end

