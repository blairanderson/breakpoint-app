class ChangeAvailableToState < ActiveRecord::Migration
  def up
    add_column :match_availabilities, :state, :string, default: 'no_response'
    add_index :match_availabilities, :state
    ActiveRecord::Base.connection.execute "UPDATE match_availabilities SET state = CASE WHEN available = 't' THEN 'yes' ELSE 'no' END"
    Team.all.each do |team|
      ActsAsTenant.with_tenant(team) do
        team.matches.each do |match|
          team.team_members.each do |team_member|
            availability = match.match_availability_for(team_member.user_id)
            if availability.new_record?
              availability.save
            end
          end
        end
      end
    end
    remove_column :match_availabilities, :available
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
