class Province < ApplicationRecord
  belongs_to :map
  belongs_to :player, optional: true # optional: true allows a province to have no owner
  has_and_belongs_to_many :nearby_provinces,
                          class_name: 'Province',
                          join_table: 'nearby_provinces',
                          foreign_key: 'province_id',
                          association_foreign_key: 'nearby_province_id'
end
