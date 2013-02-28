class Practice < ActiveRecord::Base
  include ChronicParser
  include NotifyStateMachine

  has_many   :practice_sessions, :dependent => :destroy
  has_many   :players,           :through   => :practice_sessions, :source => :user
  belongs_to :team

  attr_accessible :comment, :notified_state

  validates_presence_of :team

  def team_emails
    team.team_emails
  end

  def practice_session_for_user(user_id)
    practice_sessions.where(user_id: user_id).first
  end
end

# == Schema Information
#
# Table name: practices
#
#  id             :integer          not null, primary key
#  date           :datetime         not null
#  comment        :text
#  team_id        :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#

