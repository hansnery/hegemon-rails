class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name
      t.boolean :private
      t.integer :player_turn
      t.integer :turns_played
      t.string :phase, default: 'mustering'
      t.boolean :finished
      t.integer :winner

      t.timestamps
    end
  end
end
