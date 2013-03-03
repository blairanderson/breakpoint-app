class MatchesController < ApplicationController
  layout 'team'

  def index
    @team = Team.find(params[:team_id])
  end

  def new
    @team = Team.find(params[:team_id])
    @match = @team.matches.build
    Chronic.time_class = Time.zone
    @match.date = Chronic.parse('this 02:30 PM')
  end

  def edit
    @match = Match.find(params[:id])
    @team = @match.team
  end

  def notify
    @match = Match.find(params[:id])
    if !@match.notified_team?
      if @match.created?
        MatchMailer.match_scheduled(@match).deliver
      else
        MatchMailer.match_updated(@match).deliver
      end
      @match.notified!
      redirect_to team_matches_url(@match.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_matches_url(@match.team), :notice => 'Team has already been notified'
    end
  end

  def create
    @team = Team.find(params[:team_id])
    @match = @team.matches.build(permitted_params.match)

    if @match.save
      redirect_to team_matches_url(@team), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(permitted_params.match)
      @match.reset_notified! if @match.previous_changes.present?
      redirect_to team_matches_url(@match.team), :notice => 'Match updated'
    else
      @team = @match.team
      render :edit
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to team_matches_url(@match.team), :notice => 'Match deleted'
  end
end

