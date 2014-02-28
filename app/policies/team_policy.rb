class TeamPolicy < ApplicationPolicy
  self::Scope = Struct.new(:user, :scope) do
    def resolve
      user.teams.where(team_members: { state: 'active' }).newest
    end
  end

  def send_welcome_email?
    captain?
  end

  def create?
    captain?
  end

  def update?
    captain?
  end

  def destroy?
    captain?
  end

  def captain?
    member = user.team_members.where(:team_id => record.id).first
    return false if member.nil?
    member.captain?
  end
end

