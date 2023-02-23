require 'json'
require 'net/http'
require 'open-uri'

# Modern countries GeoJSON file
# https://datahub.io/core/geo-countries/r/countries.geojson

# url = ROMAN_EMPIRE_GEOJSON_URL
# response = Net::HTTP.get_response(URI(url))
# data = JSON.parse(response.body)

map = Map.new
map.name = "Roman Empire"
map.save

file_path = Rails.root.join('provinces.geojson')
file_contents = File.read(file_path)
data = JSON.parse(file_contents)

data['features'].map do |feature|
  province = Province.new
  province.name = feature['properties']['name']
  province.color = 'red'
  province.geometry = feature['geometry']['coordinates']
  province.map_id = map.id
  province.save
end
