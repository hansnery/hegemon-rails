class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :owner
      t.string :color
      t.string :geometry
      t.integer :armies
      t.references :map, foreign_key: true
      t.references :player, foreign_key: true

      t.timestamps
    end
  end
end
