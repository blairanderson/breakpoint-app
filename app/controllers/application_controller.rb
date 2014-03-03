class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery :with => :exception
  set_current_tenant_through_filter

  before_action :authenticate_user!
  before_action :set_current_user_and_team, if: :user_signed_in?
  around_action :user_time_zone, if: :user_signed_in?

  rescue_from Pundit::NotAuthorizedError do |exception|
    if current_user
      redirect_to request.headers["Referer"] || teams_url, :alert => 'You are not authorized to perform this action.'
      next
    end
    redirect_to root_url
  end

  def permitted_params
    @permitted_params ||= PermittedParams.new(params, current_user)
  end

  private

  def set_current_user_and_team
    if params[:team_id]
      team = policy_scope(Team).find(params[:team_id])
      set_current_tenant(team)
    end

    User.current_user = current_user
  end

  def current_team
    current_tenant
  end
  helper_method :current_team

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end
end

