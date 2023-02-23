module Hegemon
  module ProvinceUtils
    def self.assign_owners_to_provinces(provinces, num_players)
      shuffled_provinces = provinces.shuffle # Shuffle the provinces to assign them randomly
      num_provinces_per_player = shuffled_provinces.size / num_players

      owners = (1..num_players).to_a.map { |i| "Player #{i}" } # Assign player names/labels/colors

      shuffled_provinces.each_with_index do |province, index|
        owner_index = index / num_provinces_per_player # Assign owner based on the number of provinces per player
        province.owner = owners[owner_index]
      end

      return shuffled_provinces
    end
  end
end
