class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :invited_by, :class_name => 'User', :foreign_key => 'invited_by_id'
  belongs_to :team

  validates_presence_of :user, :team, :invited_by
end

