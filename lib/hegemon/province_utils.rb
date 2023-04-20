module Hegemon
  module ProvinceUtils
    def self.set_nearby_provinces(provinces)
      province_map = provinces.index_by(&:name)

      nearby_provinces_data = {
        "Britannia" => ["Lugdunensis", "Belgica"],
        "Germania Inferior" => ["Belgica", "Germania Superior"],
        "Germania Superior" => ["Belgica", "Germania Inferior", "Lugdunensis", "Narbonensis", "Alpes Graiae et Poeninae", "Raetia"],
        "Belgica" => ["Germania Inferior", "Germania Superior", "Lugdunensis", "Britannia"],
        "Lugdunensis" => ["Britannia", "Belgica", "Germania Superior", "Narbonensis", "Aquitania"],
        "Aquitania" => ["Lugdunensis", "Narbonensis", "Tarraconensis"],
        "Narbonensis" => ["Aquitania", "Lugdunensis", "Germania Superior", "Alpes Graiae et Poeninae", "Alpes Cottiae", "Alpes Maritimae", "Tarraconensis"],
        "Tarraconensis" => ["Lusitania", "Baetica", "Aquitania", "Narbonensis"],
        "Lusitania" => ["Tarraconensis", "Baetica"],
        "Baetica" => ["Lusitania", "Tarraconensis", "Mauretania Tingitana"],
        "Mauretania Tingitana" => ["Baetica", "Mauretania Caesariensis"],
        "Mauretania Caesariensis" => ["Mauretania Tingitana", "Numidia"],
        "Numidia" => ["Mauretania Caesariensis", "Africa Proconsularis"],
        "Africa Proconsularis" => ["Numidia", "Creta et Cyrene", "Sicilia"],
        "Creta et Cyrene" => ["Africa Proconsularis", "Aegyptus", "Asia", "Achaia"],
        "Aegyptus" => ["Creta et Cyrene", "Arabia"],
        "Arabia" => ["Aegyptus"]
      }

      provinces.each do |province|
        if data = nearby_provinces_data[province.name]
          data.each do |nearby_province_name|
            if nearby_province = province_map[nearby_province_name]
              province.nearby_provinces << nearby_province
            end
          end
        end
      end
    end
  end
end
