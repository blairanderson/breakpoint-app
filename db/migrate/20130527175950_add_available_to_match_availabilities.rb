class AddAvailableToMatchAvailabilities < ActiveRecord::Migration
  def change
    add_column :match_availabilities, :available, :boolean
    execute 'UPDATE match_availabilities SET available = true'
  end
end
