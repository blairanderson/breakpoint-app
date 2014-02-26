class TeamMember < ActiveRecord::Base
  ROLES = %w[captain co-captain member]
  STATES = %w[not_invited, invited, active, inactive]

  belongs_to :user
  belongs_to :team

  validates :receive_email, absence: { message: "can't be checked when team membership is inactive" }, if: :inactive?

  delegate :not_invited?, :invited?, :accepted?, :inactive?, :to => :current_state

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
    update!(state: "invited")
  end

  def activate!(current_user_id)
    invite = Invite.where(team_id: team_id, user_id: user_id).first
    if invite.new_record?
      invite.invited_by_id = current_user_id
      invite.save!
      update!(state: "invited", receive_email: true)
    elsif invite.accepted?
      update!(state: "active", receive_email: true)
    elsif invite.user_id == current_user_id
      invite.update!(accepted_at: Time.zone.now)
      update!(state: "active", receive_email: true)
    else
      current_user = User.find(current_user_id)
      InviteMailer.delay.invitation(from:      current_user.name,
                                    reply_to:  current_user.email,
                                    invite_id: invite.id)
      update!(state: "invited", receive_email: true)
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

