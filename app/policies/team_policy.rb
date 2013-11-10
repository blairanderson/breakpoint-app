class TeamPolicy < ApplicationPolicy
  def update?
    captain?
  end
  
  def captain?
    member = user.team_members.where(:team_id => record.id).first
    return false if member.nil?
    member.captain?
  end
end

