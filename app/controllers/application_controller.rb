class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery

  before_filter :authenticate_user!
  around_filter :user_time_zone, if: :current_user

  rescue_from Pundit::NotAuthorizedError do |exception|
    if current_user
      return redirect_to root_url, :alert => 'You are not authorized to access this page.'
    end
    redirect_to new_user_session_path
  end

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  private

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end

