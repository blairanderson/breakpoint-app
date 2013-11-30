class TeamPolicy < ApplicationPolicy
  def create?
    captain?
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
  
  def captain?
    member = user.team_members.where(:team_id => record.id).first
    return false if member.nil?
    member.captain?
  end
end

