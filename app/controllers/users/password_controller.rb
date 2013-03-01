class Users::PasswordsController < Devise::PasswordsController
  def resource_params
    permitted_params.user
  end

  private :resource_params
end

