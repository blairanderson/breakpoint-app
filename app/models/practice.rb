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
#  comment    :text
#  created_at :datetime         not null
#  date       :datetime         not null
#  id         :integer          not null, primary key
#  season_id  :integer          default(0), not null
#  updated_at :datetime         not null
#

