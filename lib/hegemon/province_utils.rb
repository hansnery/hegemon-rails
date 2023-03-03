module Hegemon
  module ProvinceUtils
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
          nearby_provinces = ["Numidia", "Creta et Cyrene", "Sicilia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Creta et Cyrene"
          nearby_provinces = ["Africa Proconsularis", "Aegyptus", "Asia", "Achaia"]
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
        if province.name == "Arabia"
          nearby_provinces = ["Aegyptus", "Iudaea", "Syria"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Iudaea"
          nearby_provinces = ["Arabia", "Syria"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Syria"
          nearby_provinces = ["Arabia", "Iudaea", "Armenia Mesopotamia", "Galatia et Cappadocia", "Cilicia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Cyprus"
          nearby_provinces = ["Cilicia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Cilicia"
          nearby_provinces = ["Syria", "Cyprus", "Galatia et Cappadocia", "Lycia et Pamphylia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Lycia et Pamphylia"
          nearby_provinces = ["Asia", "Galatia et Cappadocia", "Cilicia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Armenia Mesopotamia"
          nearby_provinces = ["Syria", "Galatia et Cappadocia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Galatia et Cappadocia"
          nearby_provinces = ["Armenia Mesopotamia", "Syria", "Cilicia", "Lycia et Pamphylia", "Asia", "Bithynia et Pontus"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Asia"
          nearby_provinces = ["Creta et Cyrene", "Achaia", "Macedonia", "Thracia", "Lycia et Pamphylia", "Galatia et Cappadocia", "Bithynia et Pontus"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Bithynia et Pontus"
          nearby_provinces = ["Thracia", "Asia", "Galatia et Cappadocia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Achaia"
          nearby_provinces = ["Macedonia", "Thracia", "Asia", "Creta et Cyrene", "II", "III"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Macedonia"
          nearby_provinces = ["Achaia", "Thracia", "Asia", "Moesia Superior", "Dalmatia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Thracia"
          nearby_provinces = ["Macedonia", "Moesia Superior", "Moesia Inferior", "Bithynia et Pontus", "Asia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Moesia Inferior"
          nearby_provinces = ["Dacia", "Moesia Superior", "Thracia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Moesia Superior"
          nearby_provinces = ["Dalmatia", "Pannonia Inferior", "Dacia", "Moesia Inferior", "Thracia", "Macedonia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Dacia"
          nearby_provinces = ["Moesia Superior", "Moesia Inferior"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Dalmatia"
          nearby_provinces = ["X", "Pannonia Superior", "Pannonia Inferior", "Moesia Superior", "Macedonia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Pannonia Inferior"
          nearby_provinces = ["Pannonia Superior", "Dalmatia", "Moesia Superior"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Pannonia Superior"
          nearby_provinces = ["Pannonia Inferior", "Dalmatia", "X", "Noricum"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Noricum"
          nearby_provinces = ["Pannonia Superior", "X", "XI", "Raetia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Raetia"
          nearby_provinces = ["Germania Superior", "Alpes Graiae et Poeninae", "XI", "Noricum"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Alpes Graiae et Poeninae"
          nearby_provinces = ["Germania Superior", "Narbonensis", "Alpes Cottiae", "XI", "Raetia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Alpes Cottiae"
          nearby_provinces = ["Alpes Graiae et Poeninae", "Narbonensis", "Alpes Maritimae", "XI", "IX"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Alpes Maritimae"
          nearby_provinces = ["Alpes Cottiae", "Narbonensis", "IX"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "IX" # Genua
          nearby_provinces = ["Alpes Maritimae", "Alpes Cottiae", "XI", 'VIII', 'VII']
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "XI" # Mediolanum
          nearby_provinces = ["IX", "Alpes Cottiae", "Alpes Graiae et Poeninae", 'Raetia', 'Noricum', "X", "VIII"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "X" # Aquileia
          nearby_provinces = ["VIII", "XI", "Noricum", 'Pannonia Superior', "Dalmatia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "VIII" # Ravenna
          nearby_provinces = ["X", "XI", "IX", 'VII', "VI"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "VII" # Arretium
          nearby_provinces = ["IX", "VIII", "VI", 'IV', "I"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "VI" # Ariminium
          nearby_provinces = ["VIII", "VII", "IV", 'V']
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "V" # Ancona
          nearby_provinces = ["VI", "IV"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "IV" # Umbria
          nearby_provinces = ["VII", "VI", "V", "I", "II"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "I" # Roma
          nearby_provinces = ["VII", "IV", "II", "III"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "II" # Brundinium
          nearby_provinces = ["IV", "I", "III", "Achaia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "III" # Rhegium
          nearby_provinces = ["I", "II", "Sicilia", "Achaia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Sicilia"
          nearby_provinces = ["III", "Africa Proconsularis", "Sardinia et Corsica"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        if province.name == "Sardinia et Corsica"
          nearby_provinces = ["Sicilia"]
          nearby_provinces.each do |nearby_province|
            province.nearby_provinces << provinces.find_by(name: nearby_province)
          end
        end
        province.save
      end
    end
  end
end
