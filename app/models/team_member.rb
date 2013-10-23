class TeamMember < ActiveRecord::Base
  ROLES = %w[captain co-captain member]
  Active        = "Active"
  ActiveNoEmail = "Active, no email"
  Inactive      = "Inactive"
  Statuses      = [Active, ActiveNoEmail, Inactive]

  belongs_to :user
  belongs_to :team

  def captain?
    role == 'captain' || role == 'co-captain'
  end

  def status
    if active?
      receive_email? ? Active : ActiveNoEmail
    else
      Inactive
    end
  end

  def status=(value)
    if value == Active
      self.active = true
      self.receive_email = true
    elsif value == ActiveNoEmail
      self.active = true
      self.receive_email = false
    elsif value == Inactive
      self.active = false
      self.receive_email = false
    end
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

