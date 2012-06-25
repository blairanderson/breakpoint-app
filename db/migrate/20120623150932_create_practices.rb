class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.datetime   :date,   :null => false
      t.text       :comment
      t.references :season, :null => false, :default => ''

      t.timestamps
    end
    add_index :practices, :season_id
  end
end
