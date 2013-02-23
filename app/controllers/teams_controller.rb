class TeamsController < ApplicationController
  def index
    @teams = current_user.teams.newest
  end

  def show
    @team = Team.find(params[:id])
    render :layout => 'team'
  end

  def new
    @team = Team.new
  end

  def edit
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(params[:team])
    @team.users << current_user

    if @team.save
      redirect_to team_invites_url(@team), :notice => 'Team created'
    else
      render :new
    end
  end

  def update
    @team = Team.find(params[:id])

    if @team.update_attributes(params[:team])
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

