$(document).ready(function() {
  // Set constants
  const gameId = window.location.pathname.split('/')[2];
  const mapId = window.location.pathname.split('/')[4];

  // Get the URL to fetch data from the Rails controller
  var mapUrl = '/games/' + gameId + '/maps/' + mapId + '/'

  function getDataAndRun() {
    return new Promise(function(resolve, reject) {
      $.ajax({
        url: mapUrl,
        dataType: 'json',
        success: function(data) {
          provinces = data; // Assign the received data to the provinces variable
          resolve(data);    // Resolve the Promise with the received data

          // Map settings
          var map = L.map('map', {
            minZoom: 5,
            maxZoom: 7
          }).setView([51.505, -0.09], 13);

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
            // if (zoom == 4) {
            //   return '8px';
            // } else if (zoom > 4 && zoom < 6) {
            //   return '16px';
            // } else {
            //   return '18px';
            // }
            return '1.1rem';
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

          // Function to get the color from the Ruby object
          function getProvinceColor(name) {
            province = provinces.find(province => province.name === name);
            return province.color;
          }

          function getProvinceOwner(name) {
            province = provinces.find(province => province.name === name);
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
                layer.bindTooltip('<div class="province-title">' + getProvinceName(feature.properties.name) + '</div><div class="province-desc"><hr class="my-0">Owned by ' + provinceOwner + '</div>').openTooltip();
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

          function restoreProvincesColors(layer, feature) {
            layer.setStyle(function(feature) {
              return {
                fillColor: getProvinceColor(feature.properties.name),
                color: 'black',
                weight: 1,
                fillOpacity: 0.5
              };
            });
          }

          function addProvinceLabel(layer, feature) {
            var labelContent = '<div class="leaflet-label">' + getProvinceName(feature.properties.name) + '</div>';
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
          }

          // Set global variables
          var firstClickedProvince;
          var secondClickedProvince;
          var armyMarkerClicked = false;

          function handleArmyMovement(feature, e, provincesLayer, nearbyProvinces) {
            // First click
            var availableArmies = (getProvinceArmies(feature.properties.name) - 1);
            // console.log('Available armies:', availableArmies);

            if(!armyMarkerClicked && availableArmies > 0) {
              if(availableArmies > 1) {
                var popupContent = '<div class="popup-slider-container"><label for="num-armies-slider">' + 1 + '</label><input type="range" id="num-armies-slider" name="num-armies-slider" value="' + availableArmies + '" min="1" max="' + availableArmies + '"><span>' + availableArmies + '</span></div>';
                var popupOptions = {
                  maxWidth: 130,
                  offset: [10, -20]
                };
                var popup = L.popup(popupOptions)
                  .setLatLng(e.latlng)
                  .setContent(popupContent)
                  .openOn(map);
              }

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
            } else if (armyMarkerClicked) { // Second click
              var armiesSlider = document.getElementById('num-armies-slider');
              var selectedArmies = armiesSlider ? armiesSlider.value : 1;

              // console.log('Number of armies selected:', selectedArmies);

              secondClickedProvince = getProvince(feature.properties.name);
              armyMarkerClicked = false;

              // Make POST request to Rails backend
              fetch('/games/' + gameId + '/maps/' + mapId + '/' + firstClickedProvince.id + '/marches_to/' + secondClickedProvince.id + '/' + selectedArmies)
                .then(response => {
                  if (!response.ok) {
                    throw new Error('Network response was not ok');
                  }
                  return response.json();
                })
                .then(data => {
                  // console.log('Success!', data);

                  // Select all elements with class "army-number"
                  var armyNumbers = document.querySelectorAll('.army-number');

                  // Loop through the armyNumbers and update their innerHTML
                  for (var i = 0; i < armyNumbers.length; i++) {
                    armyNumbers[i].innerHTML = data[i].armies;
                  }

                  // Loop through the provinces and update them
                  for (var i = 0; i < provinces.length; i++) {
                    provinces[i].owner = data[i].owner;
                    provinces[i].armies = data[i].armies;
                    provinces[i].color = data[i].color;
                  }
                  restoreProvincesColors(provincesLayer);
                })
                .catch(error => {
                  console.error('Error:', error);
                });

              restoreProvincesColors(provincesLayer, feature);
            }
          }

          function addArmyMarkerToMap(armyMarker, map) {
            // Declare a new layerGroup for armyMarker
            var armyLayer = L.layerGroup();

            // Add armyMarker to the layerGroup
            armyLayer.addLayer(armyMarker);

            // Add the layerGroup to the map
            armyLayer.addTo(map);
          }

          function drawMap() {
            $.ajax({
              url: 'https://cdn.jsdelivr.net/gh/klokantech/roman-empire@master/data/provinces.geojson',
              dataType: 'json',
              success: function(data) {
                var provincesLayer = L.geoJSON(data, {
                  // Color province
                  style: function(feature) {
                    return {
                      fillColor: getProvinceColor(feature.properties.name),
                      color: 'black',
                      weight: 1,
                      fillOpacity: 0.5
                    };
                  },
                  // On each province do the following
                  onEachFeature: function(feature, layer) {
                    // Bind tooltip showing owner of province but only when clicked
                    bindProvinceOwnerTooltip(layer, feature);

                    // Ensure that a label is only added to a province if that province has a "name" property in its GeoJSON data.
                    if (feature.properties && feature.properties.name) {
                      // Province label
                      addProvinceLabel(layer, feature);

                      // Create army marker
                      var armyMarker = L.marker(layer.getBounds().getCenter(), {
                        icon: L.divIcon({
                          className: 'army-marker',
                          html: '<img class="army-icon" src="https://img.icons8.com/external-others-pike-picture/256/external-Legionary-rome-others-pike-picture.png"/><div class="army-number" style="position:absolute; top: 32px; left:22px;">' + getProvinceArmies(feature.properties.name) + '</div>',
                          iconSize: [45, 28],
                          iconAnchor: [15, 35]
                        })
                      });

                      // Add army marker to the map
                      addArmyMarkerToMap(armyMarker, map);

                      // Get nearby provinces
                      var nearbyProvinces = getProvinceNearbyProvinces(feature.properties.name);

                      // When armyMarker is clicked highlight nearby provinces and handles army movements
                      armyMarker.on('click', function(e) {
                        handleArmyMovement(feature, e, provincesLayer, nearbyProvinces);
                      });

                      // If map is clicked cancels army movements and restore provinces colors
                      map.on('click', function(e) {
                        armyMarkerClicked = false;
                      });
                    }
                  }
                }).addTo(map);
              }
            });
          }

          drawMap();
        },
        error: function(error) {
          reject(error); // Reject the Promise if there is an error
        }
      });
    });
  }

  getDataAndRun();
});
