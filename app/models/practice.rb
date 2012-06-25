class Practice < ActiveRecord::Base
  include ChronicParser

  has_many   :practice_sessions, :dependent => :destroy
  has_many   :users,             :through   => :practice_sessions
  belongs_to :season

  attr_accessible :comment

  validates_presence_of :season
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

