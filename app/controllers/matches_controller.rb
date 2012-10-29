class MatchesController < ApplicationController
  load_and_authorize_resource :season
  load_and_authorize_resource :match, :through => :season

  def new
  end

  def edit
  end

  def create
    if @match.save
      redirect_to @season, :notice => 'Match created'
    else
      render :new
    end
  end

  def update
    if @match.update_attributes(params[:match])
      redirect_to @season, :notice => 'Match updated'
    else
      render :edit
    end
  end

  def destroy
    @match.destroy

    redirect_to @season, :notice => 'Match deleted'
  end
end
