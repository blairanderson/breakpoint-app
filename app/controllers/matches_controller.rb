class MatchesController < ApplicationController
  layout 'team'

  def index
    @upcoming_matches = current_team.upcoming_matches
    @previous_matches = current_team.previous_matches
  end

  def new
    @match = current_team.matches.build
    @match.date = Time.zone.now.change(hour: 14, min: 30)
  end

  def edit
    @match = Match.find(params[:id])
    authorize current_team
  end

  def availability_email
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if !@match.updated?
      @match_scheduled = MatchMailer.match_scheduled(@match,
                                                     current_user.email,
                                                     from:     current_user.name,
                                                     reply_to: current_user.email,
                                                     user_id:  current_user.id)
    else
      @match_updated = MatchMailer.match_updated(@match,
                                                 current_user.email,
                                                 from:           current_user.name,
                                                 reply_to:       current_user.email,
                                                 user_id:        current_user.id,
                                                 recent_changes: @match.recent_changes)
    end
  end

  def lineup_email
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if !@match.lineup_updated?
      @match_lineup_set = MatchMailer.match_lineup_set(@match,
                                                       current_user.email,
                                                       from:     current_user.name,
                                                       reply_to: current_user.email)
    else
      @match_lineup_updated = MatchMailer.match_lineup_updated(@match,
                                                               current_user.email,
                                                               from:           current_user.name,
                                                               reply_to:       current_user.email,
                                                               recent_changes: @match.recent_changes)
    end
  end

  def notify
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if @match.created?
      Match.delay.notify(:scheduled,
                         from:     current_user.name,
                         reply_to: current_user.email,
                         match_id: @match.id)
    else
      Match.delay.notify(:updated,
                         from:           current_user.name,
                         reply_to:       current_user.email,
                         match_id:       @match.id,
                         recent_changes: @match.recent_changes)
    end

    @match.notified!
    redirect_to team_matches_url(@match.team), :notice => 'Availability request email sent to team'
  end

  def notify_lineup
    @match = Match.find(params[:id])
    authorize current_team, :update?

    if @match.lineup_created?
      Match.delay.notify(:lineup_set,
                         from:     current_user.name,
                         reply_to: current_user.email,
                         comments: params[:comments],
                         match_id: @match.id)
    else
      Match.delay.notify(:lineup_updated,
                         from:           current_user.name,
                         reply_to:       current_user.email,
                         comments:       params[:comments],
                         match_id:       @match.id)
    end

    @match.notified_lineup!
    redirect_to team_matches_url(@match.team), :notice => 'Lineup email sent to team'
  end

  def create
    @match = current_team.matches.build(permitted_params.match)
    authorize current_team

    if @match.save
      redirect_to team_matches_url(current_team), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])
    authorize current_team

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
    authorize current_team
    @match.destroy

    redirect_to team_matches_url(@match.team), :notice => 'Match deleted'
  end
end

