class InvitePolicy < ApplicationPolicy
  def update?
    user.id == record.user_id
  end
end

