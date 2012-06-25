class MatchLineup < ActiveRecord::Base
  belongs_to :user
  belongs_to :match

  attr_accessible :user_id, :match, :match_type, :ordinal
end
