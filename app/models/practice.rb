class Practice < ActiveRecord::Base
  include DateTimeParser
  include NotifyStateMachine

  has_many   :practice_sessions, :dependent => :destroy
  has_many   :players,           :through   => :practice_sessions, :source => :user
  belongs_to :team

  validates_presence_of :team

  has_paper_trail :ignore => [:notified_state]

  def practice_session_for_user(user_id)
    practice_sessions.where(user_id: user_id).first
  end

  def recent_changes
    versions.last.changeset
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
#  location       :text
#

