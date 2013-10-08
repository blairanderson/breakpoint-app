class PracticePolicy < ApplicationPolicy
  def set_availabilities?
    user.teams.include?(record.team)
  end
end