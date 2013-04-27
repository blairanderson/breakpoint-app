class MatchSet < ActiveRecord::Base
  belongs_to :match_lineup

  validates :ordinal,      :presence => true
  validates :match_lineup, :presence => true
end

