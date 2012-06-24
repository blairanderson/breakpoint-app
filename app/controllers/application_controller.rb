class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization :unless => :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      return redirect_to root_url, :alert => exception.message
    end
    redirect_to new_user_session_path
  end
end