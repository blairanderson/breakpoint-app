class Player < ActiveRecord::Base
  belongs_to :season
  belongs_to :user

  validates_presence_of :season, :user
end
