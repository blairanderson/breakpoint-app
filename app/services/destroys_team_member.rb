class DestroysTeamMember
  attr_reader :team_member

  def initialize(team_member)
    @team_member = team_member
  end

  # This is only setup to auto-destroy the association when you destroy a team_member.
  # I guess it could be in an after_destroy callback too, but it's all pretty magicky.
  # This only works because match_availability uses the current_team tenant to scope
  # records. If it didn't, then all the user's match_availabilities would get destroyed
  # and not just the ones for this team. Which makes me think that match_availability
  # should really have a foreign_key for team_member, not user. Then, we could remove
  # the primary_key and foreign_key options here, and destroying match_availabilities
  # wouldn't rely on the current_team tenant being set to properly destroy records.
  def destroy
    TeamMember.transaction do
      PracticeSession.where(user_id: team_member.user_id).each(&:destroy)
      MatchAvailability.where(user_id: team_member.user_id).each(&:destroy)
      MatchPlayer.where(user_id: team_member.user_id).each do |player|
        player.update_attributes(user_id: nil)
      end
      team_member.destroy
    end
  end
end

