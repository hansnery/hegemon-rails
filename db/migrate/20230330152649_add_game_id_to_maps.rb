class AddGameIdToMaps < ActiveRecord::Migration[7.0]
  def change
    add_reference :maps, :game, null: false, foreign_key: true
  end
end
