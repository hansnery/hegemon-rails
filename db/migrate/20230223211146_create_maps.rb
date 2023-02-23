class CreateMaps < ActiveRecord::Migration[7.0]
  def change
    create_table :maps do |t|
      t.string :name
      t.integer :min_players
      t.integer :max_players

      t.timestamps
    end
  end
end
