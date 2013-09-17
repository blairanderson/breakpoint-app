class TeamMembersController < ApplicationController
  layout 'team'

  def index
    @team = Team.find(params[:team_id])
    @accepted_team_members     = @team.accepted_team_members
    @not_accepted_team_members = @team.not_accepted_team_members
  end

  def edit
    @team_member = TeamMember.find(params[:id])
    @team = @team_member.team
  end

  def update
    @team_member = TeamMember.find(params[:id])
    @team = @team_member.team

    if @team_member.update_attributes(permitted_params.team_member)
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member updated'
    else
      render :edit
    end
  end
end

