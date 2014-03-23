class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def destroy
    ActsAsTenant.configuration.require_tenant = false
    super
  ensure
    ActsAsTenant.configuration.require_tenant = true
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { permitted_params.user }
    devise_parameter_sanitizer.for(:account_update) { permitted_params.user }
  end
end

