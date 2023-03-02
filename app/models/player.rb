class Player < ApplicationRecord
  belongs_to :map
  has_many :provinces, class_name: "Province", foreign_key: "player_id"
end
