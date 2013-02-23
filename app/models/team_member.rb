class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
end

# == Schema Information
#
# Table name: players
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  team_id  :integer          default(0), not null
#  updated_at :datetime         not null
#  user_id    :integer          default(0), not null
#

