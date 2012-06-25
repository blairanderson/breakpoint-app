class MatchLineupsController < ApplicationController
  load_and_authorize_resource :match
  load_and_authorize_resource :match_lineup, :through => :match

  def edit
  end
end