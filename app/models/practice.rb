class Practice < ActiveRecord::Base
  include ChronicParser
  include NotifyStateMachine

  has_many   :practice_sessions, :dependent => :destroy
  has_many   :users,             :through   => :practice_sessions
  belongs_to :season

  attr_accessible :comment, :notified_state

  validates_presence_of :season

  def team_emails
    season.team_emails
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
#  season_id      :integer          default(0), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  notified_state :string(255)
#

