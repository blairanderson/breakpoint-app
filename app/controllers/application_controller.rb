class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_filter :authenticate_user!

  rescue_from Pundit::NotAuthorizedError do |exception|
    if current_user
      return redirect_to root_url, :alert => 'You are not authorized to access this page.'
    end
    redirect_to new_user_session_path
  end
end

