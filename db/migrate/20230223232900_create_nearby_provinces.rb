class CreateNearbyProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :nearby_provinces, id: false do |t|
      t.belongs_to :province
      t.belongs_to :nearby_province, class_name: "Province"

      t.timestamps
    end

    add_index :nearby_provinces, [:province_id, :nearby_province_id], unique: true
  end
end
