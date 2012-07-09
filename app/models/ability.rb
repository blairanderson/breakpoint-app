class Ability
  include CanCan::Ability

  def initialize(user)
    raise CanCan::AccessDenied.new('Not authorized!') unless user

    if user.admin?
      can :manage, :all
    elsif user.captain?
      can :manage, :all
    else
      can :manage, PracticeSession, :user_id => user.id
      can :manage, MatchAvailability, :user_id => user.id
      # TODO only if in season
      can :manage, Practice
      can :manage, Match
      can :manage, Season
    end
  end
end
