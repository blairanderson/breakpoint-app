class MatchAvailability < ActiveRecord::Base
  include DestroyedAt
  STATES = %w[no_response yes maybe no]

  belongs_to :user
  belongs_to :match

  validates :team, presence: true

  acts_as_tenant :team

  delegate :yes?, :maybe?, :no?, :no_response?, :to => :current_state

  def self.no_response
    where(state: 'no_response')
  end

  def self.available
    where(state: 'yes')
  end

  def self.maybe_available
    where(state: 'maybe')
  end

  def self.not_available
    where(state: 'no')
  end

  def current_state
    state.inquiry
  end
end

# == Schema Information
#
# Table name: match_availabilities
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  match_id   :integer
#  updated_at :datetime         not null
#  user_id    :integer
#

