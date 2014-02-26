class AddStateToTeamMembers < ActiveRecord::Migration
  def up
    add_column :team_members, :state, :string, default: "not-invited", null: false
    TeamMember.all.each do |tm|
      invite = Invite.where(user_id: tm.user_id).first
      state = "not_invited"
      if tm.read_attribute(:active)
        if invite.present?
          if invite.accepted?
            state = "active"
          else
            state = "invited"
          end
        else
          state = "active"
        end
      else
        state = "inactive"
      end
      tm.update_attributes(state: state)
    end
    remove_column :team_members, :active
    change_column_default :team_members, :receive_email, false
  end

  def down
    add_column :team_members, :active, :boolean, :default => true, :null => false
    TeamMember.all.each do |tm|
      tm.update_attributes(active: tm.state != "inactive")
    end
    remove_column :team_members, :state
    change_column_default :team_members, :receive_email, true
  end
end
