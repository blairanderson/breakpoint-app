class MatchAvailabilitiesController < ApplicationController
  load_and_authorize_resource :match
  load_and_authorize_resource :match_availability, :through => :match

  def create
    @match_availability.user = current_user
    @match_availability.save

    redirect_to @match.season
  end

  def destroy
    @match_availability.destroy

    redirect_to @match.season
  end
end