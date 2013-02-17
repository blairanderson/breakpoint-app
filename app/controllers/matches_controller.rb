class MatchesController < ApplicationController
  def new
    @season = Season.find(params[:season_id])
    @match = @season.matches.build
  end

  def edit
    @match = Match.find(params[:id])
  end

  def create
    @season = Season.find(params[:season_id])
    @match = @season.matches.build(params[:match])

    if @match.save
      redirect_to season_url(@season), :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    @match = Match.find(params[:id])

    if @match.update_attributes(params[:match])
      redirect_to season_url(@match.season), :notice => 'Match updated'
    else
      render :edit
    end
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    redirect_to season_url(@match.season), :notice => 'Match deleted'
  end
end

