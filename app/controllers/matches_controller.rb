class MatchesController < ApplicationController
  layout 'team'

  def index
    @upcoming_matches = current_team.upcoming_matches
    @previous_matches = current_team.previous_matches
  end

  def new
    @match = current_team.matches.build
    Chronic.time_class = Time.zone
    @match.date = Chronic.parse('this 02:30 PM')
  end

  def edit
    @match = Match.find(params[:id])
  end

  def notify
    @match = Match.find(params[:id])

    if !@match.notified_team?
      if @match.created?
        MatchMailer.delay.match_scheduled(current_team.id, @match.id)
      else
        MatchMailer.delay.match_updated(current_team.id, @match.id, @match.recent_changes)
      end

      @match.notified!
      redirect_to team_matches_url(@match.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_matches_url(@match.team), :notice => 'Team has already been notified'
    end
  end

  def notify_lineup
    @match = Match.find(params[:id])

    if !@match.notified_team_lineup?
      if @match.lineup_created?
        MatchLineupMailer.delay.lineup_set(current_team.id, @match.id)
      else
        # TODO gotta get the changes of the lineup
        MatchLineupMailer.delay.lineup_updated(current_team.id, @match.id, [])
      end

      @match.notified_lineup!
      redirect_to team_matches_url(@match.team), :notice => 'Notification email sent to team'
    else
      redirect_to team_matches_url(@match.team), :notice => 'Team has already been notified of the lineup'
    end
  end

  def create
    @match = current_team.matches.build(permitted_params.match)

    if @match.save
      redirect_to team_matches_url(current_team), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(permitted_params.match)
      @match.reset_notified! if @match.previous_changes.present?
      if params[:commit] == 'Save results'
        redirect_to team_results_url(@match.team), :notice => 'Results updated'
      else
        # detect lineup changes and only reset then
        @match.reset_notified_lineup!
        redirect_to team_matches_url(@match.team), :notice => 'Match updated'
      end
    else
      render :edit
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to team_matches_url(@match.team), :notice => 'Match deleted'
  end
end

