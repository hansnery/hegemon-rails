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

  // Set map bounds
  map.setMaxBounds(bounds);

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

  // Set global variables and constants
  // const mapId = provinces[0].map_id;
  var firstClickedProvince = 0;
  var secondClickedProvince = 0;
  var armyMarkerClicked = false;
  const mapId = window.location.pathname.split('/')[2];

  // Variable to get the JSON element from the page and create the Ruby objects
  let provinces_json = document.getElementById("provinces-json");
  var provinces = JSON.parse(provinces_json.textContent);
  provinces_json.remove(); // Removes provinces-json element from the view

  // Function to get the color from the Ruby object
  function getProvinceColor(name) {
    province = provinces.find(province => province.name === name);
    return province.color;
  }

  function getProvinceOwner(name) {
    province = provinces.find(province => province.name === name);
    console.log(provinces);
    if (province.owner == null) {
      return 'Barbarians';
    } else {
      return province.owner;
    }
  }

  // Function to rename provinces and to get the name from the Ruby object
  // Did this so that the GeoJSON remains unmodified
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

  function getProvinceArmies(name) {
    return provinces.find(province => province.name === name).armies;
  }

  function getProvinceNearbyProvinces(name) {
    const nearbyProvinces = provinces.find(province => province.name === name).nearby_provinces;
    const namesArray = [];

    nearbyProvinces.forEach(function(object) {
      namesArray.push(object.name);
    });

    return namesArray
  }

  function getProvince(name) {
    return provinces.find(province => province.name === name);
  }

  function bindProvinceOwnerTooltip(layer, feature) {
    var tooltipBound = false;

    // Province owner tooltip
    layer.on('click', function(e) {
      if (!tooltipBound) { // bind tooltip only if it hasn't already been bound
        var provinceOwner = getProvinceOwner(feature.properties.name)
        layer.bindTooltip('<div class="province-title">' + feature.properties.name + '</div><div class="province-desc"><hr>Owned by ' + provinceOwner + '</div>').openTooltip();
        tooltipBound = true;
      }
    });
    layer.on('mouseover', function(e) {
      if (tooltipBound) { // unbind tooltip if it has been bound
        layer.unbindTooltip();
        tooltipBound = false;
      }
    });
  }

  // Declare a new layerGroup for armyMarker
  var armyLayer = L.layerGroup();

  function drawMap() {
    $.ajax({
      url: 'https://cdn.jsdelivr.net/gh/klokantech/roman-empire@master/data/provinces.geojson',
      dataType: 'json',
      success: function(data) {
        var provincesLayer = L.geoJSON(data, {
          // Color province
          style: function(feature) {
            return {
              color: getProvinceColor(feature.properties.name),
              fillOpacity: 0.5
            };
          },
          // On each province do the following
          onEachFeature: function(feature, layer) {
            // Tooltip showing owner of province but only when clicked
            bindProvinceOwnerTooltip(layer, feature);

            // Ensure that a label is only added to a province if that province has a "name" property in its GeoJSON data.
            if (feature.properties && feature.properties.name) {
              // Province marker
              var labelContent = '<div class="label">' + getProvinceName(feature.properties.name) + '</div>';
              var label = L.marker(layer.getBounds().getCenter(), {
                icon: L.divIcon({
                  className: 'label-icon',
                  html: labelContent,
                  iconSize: null
                })
              }).addTo(map);

              // Set labels
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
              })

              // Add armyMarker to the layerGroup
              armyLayer.addLayer(armyMarker);

              // Add the layerGroup to the map
              armyLayer.addTo(map);

              // Get nearby provinces
              var nearbyProvinces = getProvinceNearbyProvinces(feature.properties.name);

              armyMarker.on('click', function(e) {
                // First click
                if(!armyMarkerClicked) {
                  var popupContent = '<form><input type="number" id="num-armies" name="num-armies" value="1" min="1" max="' + getProvinceArmies(feature.properties.name) + '"></form>';

                  var popupOptions = {
                    maxWidth: 200,
                    offset: [20, -20]
                  };

                  var popup = L.popup(popupOptions)
                    .setLatLng(e.latlng)
                    .setContent(popupContent)
                    .openOn(map);

                  armyMarkerClicked = true;
                  firstClickedProvince = getProvince(feature.properties.name);
                  // Highlight the neighbouring provinces
                  provincesLayer.setStyle(function(feature) {
                    if (nearbyProvinces.indexOf(feature.properties.name) !== -1) {
                      return {
                        color: getProvinceColor(feature.properties.name),
                        fillOpacity: 1.0
                      };
                    }
                  });
                } else { // Second click
                  secondClickedProvince = getProvince(feature.properties.name);
                  armyMarkerClicked = false;
                  // Make POST request to Rails backend
                  fetch('/maps/' + mapId + '/' + firstClickedProvince.id + '/marches_to/' + secondClickedProvince.id)
                    .then(response => {
                      if (!response.ok) {
                        throw new Error('Network response was not ok');
                      }
                      return response.json();
                    })
                    .then(data => {
                      console.log('Success!', data);
                      // location.reload();

                      // Select all elements with class "army-number"
                      var armyNumbers = document.querySelectorAll('.army-number');

                      // Loop through the armyNumbers and update their innerHTML
                      for (var i = 0; i < armyNumbers.length; i++) {
                        armyNumbers[i].innerHTML = data[i].armies;
                      }

                      // Loop through the provinces and update their armies
                      for (var i = 0; i < provinces.length; i++) {
                        provinces[i].armies = data[i].armies;
                      }
                    })
                    .catch(error => {
                      console.error('Error:', error);
                    });
                  // Restore the default colors of the neighbouring provinces
                  provincesLayer.setStyle(function(feature) {
                    return {
                      color: getProvinceColor(feature.properties.name),
                      fillOpacity: 0.5
                    };
                  });
                }
              });
            }
          }
        }).addTo(map);
      }
    });
  }

  // Map
  drawMap();
});
