class PracticeSessionsController < ApplicationController
  load_and_authorize_resource :practice
  load_and_authorize_resource :practice_session, :through => :practice

  def create
    @practice_session.user = current_user
    @practice_session.save

    redirect_to @practice.season
  end

  def destroy
    @practice_session.destroy

    redirect_to @practice.season
  end
end