class PermittedParams
  attr_accessor :params, :user

  def initialize(params, user)
    @params = params
    @user   = user
  end

  def match
    params.require(:match).permit(:date_string,
                                  :time_string,
                                  :opponent,
                                  :location,
                                  :home_team,
                                  :comment,
                                  :match_lineups_attributes => [:id,
                                    :match_players_attributes => [:id, :user_id],
                                    :match_sets_attributes => [:id, :games_won, :games_lost]])
  end

  def match_availabilities
    params.require(:match_availability).permit(:available)
  end

  def practice_sessions
    params.require(:practice_session).permit(:available)
  end

  def practice
    params.require(:practice).permit(:date_string, :time_string, :location, :comment)
  end

  def team
    params.require(:team).permit(:name, :email, :date_string, :singles_matches, :doubles_matches)
  end

  def team_member
    params.require(:team_member).permit(:role)
  end

  def user
    params.require(:user).permit(:email,
                                 :current_password,
                                 :password,
                                 :password_confirmation,
                                 :remember_me,
                                 :first_name,
                                 :last_name,
                                 :phone_number,
                                 :reset_password_token,
                                 :time_zone)
  end
end

