class TeamMembersController < ApplicationController
  layout 'team'

  def new
    emails = SimpleTextAreaParser.parse(params[:emails] || "")
    users = current_team.users_from_emails(emails)
    @add_team_members = AddTeamMembers.new(new_users: users[:new_users], existing_users: users[:existing_users])
  end

  def create
    @add_team_members = AddTeamMembers.new(params[:add_team_members])
    if @add_team_members.save(current_team)
      redirect_to team_team_members_url(current_team), notice: "Team members added"
    else
      render :action => 'new'
    end
  end

  def index
    @team_members = current_team.team_members.group(:state)
  end

  def edit
    @team_member = TeamMember.find(params[:id])
    authorize @team_member
  end

  def update
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    if params[:commit] == 'Activate team membership'
      @team_member.activate!(current_user.id)
      redirect_to edit_team_team_member_url(@team_member.team, @team_member), :notice => 'Team member is now active'
    elsif params[:commit] == 'Deactivate team membership'
      @team_member.deactivate!
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member is now inactive'
    else
      if @team_member.update(permitted_params.team_member)
        redirect_to team_team_members_url(@team_member.team), :notice => 'Team member updated'
      else
        flash[:error] = "You are not authorized to perform this action."
        render :edit
      end
    end
  end
end

