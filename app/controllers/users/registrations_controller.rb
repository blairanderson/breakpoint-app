class Users::RegistrationsController < Devise::RegistrationsController
  def resource_params
    permitted_params.user
  end

  private :resource_params
end

