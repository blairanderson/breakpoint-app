class MatchLineup < ActiveRecord::Base
  belongs_to :match
  has_many   :match_players, :dependent => :destroy
  has_many   :players,       :through => :match_players, :source => :user
  has_many   :match_sets,    :dependent => :destroy, :order => :ordinal

  accepts_nested_attributes_for :match_players
  accepts_nested_attributes_for :match_sets
end

# == Schema Information
#
# Table name: match_lineups
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  match_id   :integer
#  match_type :string(255)      default(""), not null
#  ordinal    :integer          not null
#  updated_at :datetime         not null
#  user_id    :integer
#

