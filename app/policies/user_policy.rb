class UserPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def update?
    user.admin? || user.id == record.id
  end

  def destroy?
    user.admin? || user.id == record.id
  end
end

