$(document).ready(function() {
  // Map settings
  let map = L.map('map', {
    minZoom: 4,
    maxZoom: 7
  }).setView([43, 16], 4);

  // Different map styles
  var Stamen_Watercolor = L.tileLayer('https://stamen-tiles-{s}.a.ssl.fastly.net/watercolor/{z}/{x}/{y}.{ext}', {
    attribution: 'Map tiles by <a href="http://stamen.com">Stamen Design</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    subdomains: 'abcd',
    minZoom: 4,
    maxZoom: 7,
    ext: 'jpg'
  });

  var Esri_WorldImagery = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
    attribution: 'Tiles &copy; Esri &mdash; Source: Esri, i-cubed, USDA, USGS, AEX, GeoEye, Getmapping, Aerogrid, IGN, IGP, UPR-EGP, and the GIS User Community'
  });

  var Esri_WorldPhysical = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer/tile/{z}/{y}/{x}', {
    attribution: 'Tiles &copy; Esri &mdash; Source: US National Park Service',
    minZoom: 4,
    maxZoom: 7,
  });

  var USGS_USImagery = L.tileLayer('https://basemap.nationalmap.gov/arcgis/rest/services/USGSImageryOnly/MapServer/tile/{z}/{y}/{x}', {
    attribution: 'Tiles courtesy of the <a href="https://usgs.gov/">U.S. Geological Survey</a>',
    minZoom: 4,
    maxZoom: 7,
  });

  // Assign style to the map
  Esri_WorldImagery.addTo(map);

  // Map bounds
  map.setMaxBounds(map.getBounds());

  // Function to get the color from the Ruby object
  var provinces = JSON.parse(document.getElementById("provinces-json").textContent);
  function getColor(name) {
    return provinces.find(province => province.name === name).color;
  }

  // Color map
  $.ajax({
    url: "https://cdn.jsdelivr.net/gh/klokantech/roman-empire@master/data/provinces.geojson",
    dataType: "json",
    success: function(data) {
      L.geoJSON(data, {
        style: function(feature) {
          return { color: getColor(feature.properties.name) };
        },
        onEachFeature: function(feature, layer) {
          if (feature.properties && feature.properties.name) {
            var labelContent = '<div class="label">' + feature.properties.name + '</div>'; /* wrap the label text in a div with the .label class */
            var label = L.marker(layer.getBounds().getCenter(), {
              icon: L.divIcon({
                className: 'label-icon', /* add a class to the divIcon */
                html: labelContent /* set the label content as the HTML of the divIcon */
              })
            }).addTo(map);
          }
        }
      }).addTo(map);
    }
  });
});
