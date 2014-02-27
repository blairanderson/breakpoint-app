class TeamMember < ActiveRecord::Base
  ROLES = %w[captain co-captain member]
  STATES = %w[new, active, inactive]

  belongs_to :user
  belongs_to :team

  delegate :new?, :accepted?, :inactive?, :to => :current_state

  def captain?
    role == 'captain' || role == 'co-captain'
  end

  def current_state
    (state || STATES.first).inquiry
  end

  def active?
    !inactive?
  end

  # TODO this is really "send welcome email" - need to update with team member info, not using an invite object
  def invite!(current_user_id)
    invite = Invite.create!(team_id: team_id, user_id: user_id, invited_by_id: current_user_id)
    InviteMailer.delay.invitation(from:      invite.invited_by.name,
                                  reply_to:  invite.invited_by.email,
                                  invite_id: invite.id)
    update!(state: "active")
  end

  def activate!
    update!(state: 'active')
  end

  def deactivate!
    update!(state: 'inactive')
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

