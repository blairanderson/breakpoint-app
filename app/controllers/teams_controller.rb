class TeamsController < ApplicationController
  def index
    @teams = current_user.accepted_teams
    @invitations = current_user.invitations.not_accepted
  end

  def new
    @team = Team.new
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(permitted_params.team)
    @team.team_members.build(user: current_user, role: TeamMember::ROLES.first)

    if @team.save
      redirect_to team_invites_url(@team), :notice => 'Team created'
    else
      render :new
    end
  end

  def update
    @team = Team.find(params[:id])

    if @team.update_attributes(permitted_params.team)
      redirect_to teams_url, :notice => 'Team updated'
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    redirect_to teams_url, :notice => 'Team deleted'
  end
end

