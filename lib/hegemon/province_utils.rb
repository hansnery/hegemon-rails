module Hegemon
  module ProvinceUtils
    def self.set_province_owners(provinces, num_players)
      shuffled_provinces = provinces.shuffle # Shuffle the provinces to assign them randomly
      num_provinces_per_player = shuffled_provinces.size / num_players

      owners = (1..num_players).to_a.map { |i| "Player #{i}" } # Assign player names/labels/colors

      shuffled_provinces.each_with_index do |province, index|
        owner_index = index / num_provinces_per_player # Assign owner based on the number of provinces per player
        province.owner = owners[owner_index]
      end

      return shuffled_provinces
    end

    def self.set_nearby_provinces(provinces)
      provinces.each do |province|
        if province.name == "Britannia"
          nearby_provinces = ["Lugdunensis", "Belgica"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Germania Inferior"
          nearby_provinces = ["Belgica", "Germania Superior"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Germania Superior"
          nearby_provinces = ["Belgica", "Germania Inferior", "Lugdunensis", "Narbonensis", "Alpes Graiae et Poeninae", "Raetia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Belgica"
          nearby_provinces = ["Germania Inferior", "Germania Superior", "Lugdunensis", "Britannia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Lugdunensis"
          nearby_provinces = ["Britannia", "Belgica", "Germania Superior", "Narbonensis", "Aquitania"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Aquitania"
          nearby_provinces = ["Lugdunensis", "Narbonensis", "Tarraconensis"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Narbonensis"
          nearby_provinces = ["Aquitania", "Lugdunensis", "Germania Superior", "Alpes Graiae et Poeninae", "Alpes Cottiae", "Alpes Maritimae", "Tarraconensis"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Tarraconensis"
          nearby_provinces = ["Lusitania", "Baetica", "Aquitania", "Narbonensis"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Lusitania"
          nearby_provinces = ["Tarraconensis", "Baetica"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Baetica"
          nearby_provinces = ["Lusitania", "Tarraconensis", "Mauretania Tingitana"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Mauretania Tingitana"
          nearby_provinces = ["Baetica", "Mauretania Caesariensis"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Mauretania Caesariensis"
          nearby_provinces = ["Mauretania Tingitana", "Numidia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Numidia"
          nearby_provinces = ["Mauretania Caesariensis", "Africa Proconsularis"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Africa Proconsularis"
          nearby_provinces = ["Numidia", "Creta et Cyrene"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Creta et Cyrene"
          nearby_provinces = ["Africa Proconsularis", "Aegyptus"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Aegyptus"
          nearby_provinces = ["Creta et Cyrene", "Arabia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        province.save
      end
    end
  end
end
