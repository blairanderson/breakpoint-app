desc "One time task to create team_member entries for all invites"
task :add_invited_to_team_members => :environment do
  puts Invite.not_accepted.count
  Invite.not_accepted.each do |invite|
    team = Team.find(invite.team_id)
    team.users << invite.user
    team.save!
  end
end

