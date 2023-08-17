
$(document).ready(function() {
  // Configuration and Constants
  const CONFIG = {
    GAME_URL: '/games/' + window.location.pathname.split('/')[2],
    MAP_URL: '/games/' + window.location.pathname.split('/')[2] + '/maps/' + window.location.pathname.split('/')[4] + '/',
    PROVINCES_URL: 'https://cdn.jsdelivr.net/gh/klokantech/roman-empire@master/data/provinces.geojson',
    ARMY_ICON_URL: 'https://img.icons8.com/external-others-pike-picture/256/external-Legionary-rome-others-pike-picture.png'
  };

  // Function to get game data
  function getGameData() {
    return new Promise(function(resolve, reject) {
      $.ajax({ url: CONFIG.GAME_URL, dataType: 'json', success: resolve, error: reject });
    });
  }

  // Function to get map data
  function getMapData() {
    return new Promise(function(resolve, reject) {
      $.ajax({ url: CONFIG.MAP_URL, dataType: 'json', success: resolve, error: reject });
    });
  }

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
        L.popup(popupOptions)
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
      fetch(CONFIG.MAP_URL + firstClickedProvince.id + '/marches_to/' + secondClickedProvince.id + '/' + selectedArmies)
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

  function getDataAndRun() {

    // Use Promise.all to make both requests concurrently
    Promise.all([getGameData(), getMapData()])
    .then(function(values) {
      // Game data: name, phase, private, player_turn, turns_played, winner
      var gameData = values[0];

      // Map data: name, min_players, max_players, num_players
      var mapData = values[1];

      // Show whose turn it is
      showMessage("It's " + getPlayerTurn(mapData.players, gameData.player_turn).name + " turn!");

      // Assign the received data to the provinces variable
      provinces = mapData.provinces;

      // Set global variables
      var firstClickedProvince;
      var secondClickedProvince;
      var armyMarkerClicked = false;

      drawMap();
    })
    .catch(function(error) {
      console.error('There was an error fetching data:', error);
    });
  }

  getDataAndRun();
});
