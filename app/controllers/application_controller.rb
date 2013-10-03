class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery :with => :exception

  before_action :authenticate_user!
  around_action :user_time_zone, if: :current_user

  rescue_from Pundit::NotAuthorizedError do |exception|
    if current_user
      redirect_to root_url, :alert => 'You are not authorized to access this page.'
      next
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

