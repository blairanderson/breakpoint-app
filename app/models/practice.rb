class Practice < ActiveRecord::Base
  include DateTimeParser
  include NotifyStateMachine

  has_many :practice_sessions, -> { joins(user: :active_teams).where('"teams"."id" = "practice_sessions"."team_id"') }, :dependent => :destroy

  validates :team, presence: true

  acts_as_tenant :team
  has_paper_trail :ignore => [:notified_state, :updated_at]

  def self.notify(name, options)
    practice = find(options.fetch(:practice_id))

    practice.team_emails(options.fetch(:reply_to)).each do |to|
      PracticeMailer.send("practice_#{name}", practice, to, options).deliver
    end
  end

  def team_emails(from = nil)
    team.team_emails.reject { |e| from == e }
  end

  def practice_session_for(user_id)
    practice_sessions.where(user_id: user_id).first_or_initialize
  end

  def available_players
    practice_sessions.includes(:user).where(:available => true).collect(&:user)
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

