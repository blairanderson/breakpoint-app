class TeamPolicy < ApplicationPolicy
  def captain?
    member = user.team_members.where(:team_id => record.id).first
    return false if member.nil?
    member.role == 'captain' || member.role == 'co-captain'
  end
end

