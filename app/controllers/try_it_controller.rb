class TryItController < ApplicationController
  skip_before_action :authenticate_user!

  def auto_sign_in
    if params[:user] == 'captain'
      sign_in :user, User.joins(:team_members).where("team_members.role = 'captain'").first
    elsif params[:user] == 'member'
      sign_in :user, User.joins(:team_members).where("team_members.role = 'member'").first
    end

    redirect_to teams_url
  end
end

