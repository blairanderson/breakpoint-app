class PracticesController < ApplicationController
  before_filter :load_season

  def new
    @practice = @season.practices.build
  end

  def edit
    @practice = Practice.find params[:id]
  end

  def create
    @practice = @season.practices.build params[:practice]

    if @practice.save
      redirect_to @season, :notice => 'Practice created'
    else
      render :new
    end
  end

  def update
    @practice = Practice.find params[:id]

    if @practice.update_attributes(params[:practice])
      redirect_to @season, :notice => 'Practice updated'
    else
      render :edit
    end
  end

  def destroy
    @practice = Practice.find params[:id]
    @practice.destroy

    redirect_to @season, :notice => 'Practice deleted'
  end

  private

  def load_season
    @season = Season.find params[:season_id]
  end
end