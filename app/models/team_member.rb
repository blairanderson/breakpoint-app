class TeamMember < ActiveRecord::Base
  ROLES = %w[captain co-captain member]
  STATES = %w[new, pending, active, inactive]

  belongs_to :user
  belongs_to :team

  validates :receive_email, absence: { message: "can't be checked when team membership is inactive" }, if: :inactive?

  delegate :new?, :pending?, :accepted?, :inactive?, :to => :current_state

  def captain?
    role == 'captain' || role == 'co-captain'
  end

  def current_state
    (state || STATES.first).inquiry
  end

  def active?
    !inactive?
  end

  def invite!(current_user_id)
    invite = Invite.create!(team_id: team_id, user_id: user_id, invited_by_id: current_user_id)
    InviteMailer.delay.invitation(from:      invite.invited_by.name,
                                  reply_to:  invite.invited_by.email,
                                  invite_id: invite.id)
    update!(state: "pending")
  end

  def activate!(current_user_id)
    invite = Invite.where(team_id: team_id, user_id: user_id).first
    if invite.nil?
      update!(state: "new", receive_email: false)
    elsif invite.accepted?
      update!(state: "active", receive_email: true)
    else
      update!(state: "pending", receive_email: true)
    end
  end

  def deactivate!
    update!(state: 'inactive', receive_email: false)
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

