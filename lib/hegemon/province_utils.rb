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
        "Arabia" => ["Aegyptus", "Iudaea", "Syria"],
        "Iudaea" => ["Arabia", "Syria"],
        "Syria" => ["Arabia", "Iudaea", "Armenia Mesopotamia", "Galatia et Cappadocia", "Cilicia"],
        "Cyprus" => ["Cilicia"],
        "Cilicia" => ["Syria", "Cyprus", "Galatia et Cappadocia", "Lycia et Pamphylia"],
        "Lycia et Pamphylia" => ["Asia", "Galatia et Cappadocia", "Cilicia"],
        "Armenia Mesopotamia" => ["Syria", "Galatia et Cappadocia"],
        "Galatia et Cappadocia" => ["Armenia Mesopotamia", "Syria", "Cilicia", "Lycia et Pamphylia", "Asia", "Bithynia et Pontus"],
        "Asia" => ["Creta et Cyrene", "Achaia", "Macedonia", "Thracia", "Lycia et Pamphylia", "Galatia et Cappadocia", "Bithynia et Pontus"],
        "Bithynia et Pontus" => ["Thracia", "Asia", "Galatia et Cappadocia"],
        "Achaia" => ["Macedonia", "Thracia", "Asia", "Creta et Cyrene", "II", "III"],
        "Macedonia" => ["Achaia", "Thracia", "Asia", "Moesia Superior", "Dalmatia"],
        "Thracia" => ["Macedonia", "Moesia Superior", "Moesia Inferior", "Bithynia et Pontus", "Asia"],
        "Moesia Inferior" => ["Dacia", "Moesia Superior", "Thracia"],
        "Moesia Superior" => ["Dalmatia", "Pannonia Inferior", "Dacia", "Moesia Inferior", "Thracia", "Macedonia"],
        "Dacia" => ["Moesia Superior", "Moesia Inferior"],
        "Dalmatia" => ["X", "Pannonia Superior", "Pannonia Inferior", "Moesia Superior", "Macedonia"],
        "Pannonia Inferior" => ["Pannonia Superior", "Dalmatia", "Moesia Superior"],
        "Pannonia Superior" => ["Pannonia Inferior", "Dalmatia", "X", "Noricum"],
        "Noricum" => ["Pannonia Superior", "X", "XI", "Raetia"],
        "Raetia" => ["Germania Superior", "Alpes Graiae et Poeninae", "XI", "Noricum"],
        "Alpes Graiae et Poeninae" => ["Germania Superior", "Narbonensis", "Alpes Cottiae", "XI", "Raetia"],
        "Alpes Cottiae" => ["Alpes Graiae et Poeninae", "Narbonensis", "Alpes Maritimae", "XI", "IX"],
        "Alpes Maritimae" => ["Alpes Cottiae", "Narbonensis", "IX"],
        "IX" => ["Alpes Maritimae", "Alpes Cottiae", "XI", 'VIII', 'VII'], # Genua
        "XI" => ["IX", "Alpes Cottiae", "Alpes Graiae et Poeninae", 'Raetia', 'Noricum', "X", "VIII"], # Mediolanum
        "X" => ["VIII", "XI", "Noricum", 'Pannonia Superior', "Dalmatia"], # Aquileia
        "VIII" => ["X", "XI", "IX", 'VII', "VI"], # Ravenna
        "VII" => ["IX", "VIII", "VI", 'IV', "I"], # Arretium
        "VI" => ["VIII", "VII", "IV", 'V'], # Ariminium
        "V" => ["VI", "IV"], # Ancona
        "IV" => ["VII", "VI", "V", "I", "II"], # Umbria
        "I" => ["VII", "IV", "II", "III"], # Roma
        "II" => ["IV", "I", "III", "Achaia"], # Brundinium
        "III" => ["I", "II", "Sicilia", "Achaia"], # Rhegium
        "Sicilia" => ["III", "Africa Proconsularis", "Sardinia et Corsica"],
        "Sardinia et Corsica" => ["Sicilia"]
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
