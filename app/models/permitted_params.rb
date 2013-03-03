class PermittedParams
  attr_accessor :params, :user

  def initialize(params, user)
    @params = params
    @user   = user
  end

  def invite
    params.require(:invite).permit(:email, :name, :user_id)
  end

  def match
    params.require(:match).permit(:date_string, :time_string, :location, :opponent, :match_lineups_attributes => [ :id, :user_id ])
  end

  def practice
    params.require(:practice).permit(:date_string, :time_string, :comment)
  end

  def team
    params.require(:team).permit(:name, :date_string, :singles_matches, :doubles_matches)
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
                                 :time_zone)
  end
end

