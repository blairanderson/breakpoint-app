class TeamMembersController < ApplicationController
  layout 'team'

  def index
    @accepted_team_members     = current_team.accepted_team_members
    @not_accepted_team_members = current_team.not_accepted_team_members
  end

  def edit
    # TODO authorize team member - captain or owner
    @team_member = TeamMember.find(params[:id])
  end

  def update
    @team_member = TeamMember.find(params[:id])

    if @team_member.update_attributes(permitted_params.team_member)
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member updated'
    else
      render :edit
    end
  end
end

