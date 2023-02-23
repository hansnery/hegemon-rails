$(document).ready(function() {
  // Map settings
  var map = L.map('map', {
    minZoom: 5,
    maxZoom: 7
  }).setView([43, 16], 5);

  // Assign style to the map
  Esri_WorldImagery.addTo(map);

  // Map bounds
  bounds = map.getBounds()
  bounds._northEast.lat = 58.52108149544362
  bounds._northEast.lng = 50.75781250000001
  bounds._southWest.lat = 18.844673680771795
  bounds._southWest.lng = -20.765625000000002
  map.setMaxBounds(bounds);

  // Function to get the color from the Ruby object
  var provinces = JSON.parse(document.getElementById("provinces-json").textContent);

  function getProvinceColor(name) {
    province_owner = provinces.find(province => province.name === name).owner
    switch(province_owner) {
      case 'Player 1':
        return 'red'
        break;
      case 'Player 2':
        return 'blue'
        break;
      case 'Player 3':
        return 'yellow'
        break;
      case 'Player 4':
        return 'green'
        break;
      default:
        return 'white'
    }
  }

  function getProvinceOwner(name) {
    province_owner = provinces.find(province => province.name === name).owner
    switch(province_owner) {
      case 'Player 1':
        return 'Player 1'
        break;
      case 'Player 2':
        return 'Player 2'
        break;
      case 'Player 3':
        return 'Player 3'
        break;
      case 'Player 4':
        return 'Player 4'
        break;
      default:
        return 'Barbarians'
    }
  }

  // Function to rename provinces and to get the name from the Ruby object
  function getProvinceName(name) {
    if (name === 'I') {
      return 'Roma';
    } else if (name === 'IX') {
      return 'Genua';
    } else if (name === 'XI') {
      return 'Mediolanum';
    } else if (name === 'X') {
      return 'Aquileia';
    } else if (name === 'VIII') {
      return 'Ravenna';
    } else if (name === 'VII') {
      return 'Arretium';
    } else if (name === 'VI') {
      return 'Ariminium';
    } else if (name === 'V') {
      return 'Ancona';
    } else if (name === 'IV') {
      return 'Umbria'; //Umbria, Interamna or Via Flaminia
    } else if (name === 'II') {
      return 'Brundinium';
    } else if (name === 'III') {
      return 'Rhegium';
    } else {
      return provinces.find(province => province.name === name).name;
    }
  }

  // Function to rename provinces and to get the name from the Ruby object
  function getProvinceArmies(name) {
    return provinces.find(province => province.name === name).armies;
  }

  // Map
  $.ajax({
    url: 'https://cdn.jsdelivr.net/gh/klokantech/roman-empire@master/data/provinces.geojson',
    dataType: 'json',
    success: function(data) {
      var provincesLayer = L.geoJSON(data, {
        style: function(feature) {
          return { color: getProvinceColor(feature.properties.name) };
        },
        // On each province do the following
        onEachFeature: function(feature, layer) {
          // Tooltip showing owner of province but only when clicked
          var tooltipBound = false; // flag to track if tooltip has been bound
          layer.on('click', function(e) {
            if (!tooltipBound) { // bind tooltip only if it hasn't already been bound
              layer.bindTooltip(getProvinceOwner(feature.properties.name)).openTooltip();
              tooltipBound = true;
            }
          });
          layer.on('mouseover', function(e) {
            if (tooltipBound) { // unbind tooltip if it has been bound
              layer.unbindTooltip();
              tooltipBound = false;
            }
          });
          if (feature.properties && feature.properties.name) {
            var labelContent = '<div class="label">' + getProvinceName(feature.properties.name) + '</div>';
            var label = L.marker(layer.getBounds().getCenter(), {
              icon: L.divIcon({
                className: 'label-icon',
                html: labelContent,
                iconSize: null
              })
            }).addTo(map);
            setLabelPosition(label, layer.getBounds().getCenter(), getProvinceName(feature.properties.name), offsets);
            map.on('zoomend', function() {
              setLabelPosition(label, layer.getBounds().getCenter(),getProvinceName(feature.properties.name), offsets);
              label.getElement().style.fontSize = getFontSize(map.getZoom());
            });
            // Set the initial font size to 8px
            label.getElement().style.fontSize = '8px';

            // Add marker to represent armies
            var armyIcon = L.divIcon({
              className: 'army-marker',
              html: '<img class="army-icon" src="https://img.icons8.com/external-others-pike-picture/256/external-Legionary-rome-others-pike-picture.png"/><div class="army-number" style="position:absolute; top: 32px; left:22px;">' + getProvinceArmies(feature.properties.name) + '</div>',
              iconSize: [45, 28],
              iconAnchor: [15, 35]
            });
            var armyMarker = L.marker(layer.getBounds().getCenter(), {
              icon: armyIcon
            }).addTo(map);
          }
        }
      }).addTo(map);
    }
  });

  function getFontSize(zoom) {
    if (zoom == 4) {
      return '8px';
    } else if (zoom > 4 && zoom < 6) {
      return '16px';
    } else {
      return '18px';
    }
  }

  function setLabelPosition(label, center, name, offsets) {
    var point = map.latLngToLayerPoint(center);
    var offset = [0, 0];
    if (name in offsets) {
      var zoom = map.getZoom();
      if (zoom in offsets[name]) {
        offset = offsets[name][zoom];
      }
    }
    var adjustedPoint = L.point(point.x + offset[0], point.y + offset[1]);
    var adjustedLatLng = map.layerPointToLatLng(adjustedPoint);
    label.setLatLng(adjustedLatLng);
  }
});
