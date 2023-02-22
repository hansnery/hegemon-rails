require 'json'
require 'net/http'
require 'open-uri'

url = ROMAN_EMPIRE_GEOJSON_URL
response = Net::HTTP.get_response(URI(url))
data = JSON.parse(response.body)

data['features'].map do |feature|
  province = Province.new
  province.name = feature['properties']['name']
  province.color = 'red'
  province.geometry = feature['geometry']['coordinates']
  province.save
end
