class MatchSet < ActiveRecord::Base
  belongs_to :match_lineup

  validates :games_won,    :presence => true
  validates :games_lost,   :presence => true
  validates :ordinal,      :presence => true
  validates :match_lineup, :presence => true
end

