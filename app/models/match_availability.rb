class MatchAvailability < ActiveRecord::Base
  belongs_to :user
  belongs_to :match

  validates :team, presence: true

  acts_as_tenant :team
end

# == Schema Information
#
# Table name: match_availabilities
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  match_id   :integer
#  updated_at :datetime         not null
#  user_id    :integer
#

