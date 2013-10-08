class PracticeSessionPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def update?
    owner?
  end

  def destroy?
    user.id == record.user_id
  end

  private

  def owner?
    user.id == record.user_id
  end
end
