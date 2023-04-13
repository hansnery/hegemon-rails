class Game < ApplicationRecord
  has_one :map, dependent: :destroy
  accepts_nested_attributes_for :map
  validates_associated :map
end
