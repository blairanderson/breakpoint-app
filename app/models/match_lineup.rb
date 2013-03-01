class MatchLineup < ActiveRecord::Base
  belongs_to :user
  belongs_to :match
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

