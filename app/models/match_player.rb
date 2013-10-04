class MatchPlayer < ActiveRecord::Base
  belongs_to :user
  belongs_to :match_lineup

  acts_as_tenant :team
end

