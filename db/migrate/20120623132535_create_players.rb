class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :season
      t.references :user

      t.timestamps
    end
    add_index :players, :season_id
    add_index :players, :user_id
  end
end
