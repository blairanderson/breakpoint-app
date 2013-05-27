class AddAvailableToMatchAvailabilities < ActiveRecord::Migration
  def change
    add_column :match_availabilities, :available, :boolean
  end
end
