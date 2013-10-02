class TeamMember < ActiveRecord::Base
  ROLES = %w[captain co-captain member]

  belongs_to :team
  belongs_to :user

  def captain?
    role == 'captain' || role == 'co-captain'
  end
end

# == Schema Information
#
# Table name: team_members
#
#  id         :integer          not null, primary key
#  team_id    :integer          default(0), not null
#  user_id    :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

