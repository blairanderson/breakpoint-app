class AddTeamMembers
  include ActiveModel::Model

  attr_accessor :team, :new_users, :existing_users

  def new_users_attributes=(attributes)
    @new_users ||= []
    attributes.each do |i, new_user_params|
      @new_users.push(User.new(new_user_params))
    end
  end

  def existing_users_attributes=(attributes)
    existing_emails = attributes.map do |i, existing_user_params|
      existing_user_params[:email]
    end
    @existing_users = User.where(email: existing_emails)
  end

  def save(team)
    @new_users ||= []
    @existing_users ||= []
    new_users.each do |user|
      user.password = SecureRandom.uuid
      user.save!
    end
    team.users.push(new_users + existing_users)
  end
end

