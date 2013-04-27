class MatchPlayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :match_lineup
end

