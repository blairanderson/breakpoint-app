class TeamMember < ActiveRecord::Base
  ROLES = %w[captain co-captain member]
  STATES = %w[new, active, inactive]

  belongs_to :user
  belongs_to :team

  delegate :new?, :active?, :inactive?, :to => :current_state

  def self.new_members
    where(state: "new")
  end

  def self.active
    where(state: "active")
  end

  def self.inactive
    where(state: "inactive")
  end

  def captain?
    role == 'captain' || role == 'co-captain'
  end

  def current_state
    (state || STATES.first).inquiry
  end

  def active?
    !inactive?
  end

  def send_welcome!(from_user_id)
    from_user = User.find(from_user_id)
    if user.never_signed_in?
      WelcomeMailer.delay.new_user_welcome(from:           from_user.name,
                                           reply_to:       from_user.email,
                                           team_member_id: id)
    else
      WelcomeMailer.delay.welcome(from:           from_user.name,
                                  reply_to:       from_user.email,
                                  team_member_id: id)
    end
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

