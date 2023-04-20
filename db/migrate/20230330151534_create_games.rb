class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name
      t.boolean :private
      t.integer :player_turn, default: 0
      t.integer :turns_played, default: 0
      t.string :phase, default: 'mustering'
      t.boolean :finished, default: false
      t.integer :winner

      t.timestamps
    end
  end
end
