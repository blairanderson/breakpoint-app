class MatchLineup < ActiveRecord::Base
  belongs_to :user
  belongs_to :match

  attr_accessible :user_id, :match, :match_type, :ordinal
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

