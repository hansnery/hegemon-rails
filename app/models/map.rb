class Map < ApplicationRecord
  has_many :provinces, class_name: "Province", foreign_key: "map_id", dependent: :destroy
  has_many :players, dependent: :destroy
  belongs_to :game
end
