class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.datetime :date
      t.text :comment
      t.references :season

      t.timestamps
    end
    add_index :practices, :season_id
  end
end
