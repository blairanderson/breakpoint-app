class TeamMembersController < ApplicationController
  layout 'team'

  def index
    @accepted_team_members     = current_team.accepted_team_members
    @not_accepted_team_members = current_team.not_accepted_team_members
  end

  def edit
    @team_member = TeamMember.find(params[:id])
    authorize @team_member
  end

  def update
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    if @team_member.update_attributes(permitted_params.team_member)
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member updated'
    else
      flash[:error] = "You are not authorized to perform this action."
      render :edit
    end
  end
end

