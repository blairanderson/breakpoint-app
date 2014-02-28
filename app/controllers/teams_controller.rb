class TeamsController < ApplicationController
  def index
    @teams = policy_scope(Team)
  end

  def send_welcome_email
    @team = current_user.teams.find(params[:id])
    authorize @team

    @team.team_members.new_members.each { |member| member.send_welcome!(current_user.id) }
    redirect_to team_team_members_url(@team), :notice => 'Welcome email sent'
  end

  def new
    @team = Team.new
  end

  def edit
    @team = current_user.teams.find(params[:id])
    authorize @team
  end

  def create
    @team = Team.new(permitted_params.team)
    @team.team_members.build(user: current_user, role: TeamMember::ROLES.first, state: "active")

    if @team.save
      redirect_to team_team_members_url(@team), :notice => 'Team created'
    else
      render :new
    end
  end

  def update
    @team = current_user.teams.find(params[:id])
    authorize @team

    if @team.update_attributes(permitted_params.team)
      redirect_to teams_url, :notice => 'Team updated'
    else
      render :edit
    end
  end

  def destroy
    @team = current_user.teams.find(params[:id])
    authorize @team
    ActsAsTenant.with_tenant(@team) { @team.destroy }

    redirect_to teams_url, :notice => 'Team deleted'
  end
end

