class TeamMembersController < ApplicationController
  layout 'team'

  def send_welcome_email
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    @team_member.send_welcome!(current_user.id)
    redirect_to team_team_members_url(current_team), :notice => 'Welcome email sent'
  end

  def new
    emails = SimpleTextAreaParser.parse(params[:emails] || "")
    @add_team_members = AddTeamMembers.users_from_emails(current_team, emails)
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
    @team_members = current_team.team_members
    @team_members_by_state = current_team.team_members.group_by(&:state)
    @captain = TeamPolicy.new(current_user, current_team).captain?
  end

  def edit
    @team_member = TeamMember.find(params[:id])
    authorize @team_member
  end

  def update
    @team_member = TeamMember.find(params[:id])
    authorize @team_member

    if params[:commit] == 'Reactivate team membership'
      @team_member.activate!
      redirect_to team_team_members_url(@team_member.team), :notice => 'Team member is now active'
    elsif params[:commit] == 'Deactivate team membership'
      if @team_member.team.captains.size == 1 && @team_member.captain?
        message = 'You are the only captain on the team and cannot be deactivated. '
        message << 'Make another player captain first before deactivating again.'
        flash[:alert] = message
        redirect_to team_team_members_url(@team_member.team)
      else
        @team_member.deactivate!
        if current_user.id == @team_member.user_id
          redirect_to teams_url, :notice => 'You have been just removed yourself from the team.'
        else
          redirect_to team_team_members_url(@team_member.team), :notice => 'Team member is now inactive'
        end

      end
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

