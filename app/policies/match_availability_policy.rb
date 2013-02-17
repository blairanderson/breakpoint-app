class MatchAvailabilityPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def destroy?
    user.id == record.user_id
  end
end

