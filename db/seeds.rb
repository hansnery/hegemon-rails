require 'json'
require 'net/http'
require 'open-uri'

# url = ROMAN_EMPIRE_GEOJSON_URL
# response = Net::HTTP.get_response(URI(url))
# data = JSON.parse(response.body)

file_path = Rails.root.join('provinces.geojson')
file_contents = File.read(file_path)
data = JSON.parse(file_contents)

# Modify a property of each feature
# data['features'].each do |feature|
#   if feature['properties']['name'] == 'I'
#     feature['properties']['name'] = 'Roma'
#   end
#   if province.name == "IX"
#     province.name = "Genua"
#     province.save
#   end
#   if province.name == "XI"
#     province.name = "Mediolanum"
#     province.save
#   end
#   if province.name == "X"
#     province.name = "Aquileia"
#     province.save
#   end
# end

# Write modified data back to GeoJSON file
# File.open('modified_provinces.geojson', 'w') do |file|
#   file.write(JSON.pretty_generate(data))
# end

# file_path = Rails.root.join('modified_provinces.geojson')
# file_contents = File.read(file_path)
# data = JSON.parse(file_contents)

data['features'].map do |feature|
  province = Province.new
  province.name = feature['properties']['name']
  province.color = 'red'
  province.geometry = feature['geometry']['coordinates']
  province.save
end
