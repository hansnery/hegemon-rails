class AddMapIdToProvinces < ActiveRecord::Migration[7.0]
  def change
    add_column :provinces, :map_id, :integer
    add_foreign_key :provinces, :maps
  end
end
