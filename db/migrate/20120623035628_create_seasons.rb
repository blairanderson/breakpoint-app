class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string   :name, :null => false, :default => ""
      t.datetime :date, :null => false

      t.timestamps
    end
  end
end
