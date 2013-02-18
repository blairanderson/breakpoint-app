class MatchesController < ApplicationController
  layout 'season'

  def index
    @season = Season.find(params[:season_id])
  end

  def new
    @season = Season.find(params[:season_id])
    @match = @season.matches.build
  end

  def edit
    @match = Match.find(params[:id])
    @season = @match.season
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
      redirect_to season_matches_url(@match.season), :notice => 'Notification email sent to team'
    else
      redirect_to season_matches_url(@match.season), :notice => 'Team has already been notified'
    end
  end

  def create
    @season = Season.find(params[:season_id])
    @match = @season.matches.build(params[:match])

    if @match.save
      redirect_to season_matches_url(@season), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(params[:match])
      @match.reset_notified! if @match.previous_changes.present?
      redirect_to season_matches_url(@match.season), :notice => 'Match updated'
    else
      @season = @match.season
      render :edit
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to season_matches_url(@match.season), :notice => 'Match deleted'
  end
end

