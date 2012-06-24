class Ability
  include CanCan::Ability

  def initialize(user)
    raise CanCan::AccessDenied.new('Not authorized!') unless user

    if user.admin?
      can :manage, :all
    elsif user.captain?
      can :manage, :all
    else
      can :manage, PracticeSession do |practice_session|
        practice_session.practice.season.users.include? user
      end
      can :manage, MatchAvailability do |match_availability|
        match_availability.match.season.users.include? user
      end
      can :read, :all
    end
  end
end
