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
  function getProvinceColor(name) {
    return provinces.find(province => province.name === name).color;
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

  // Set provinces labels offsets
  var offsets = {
    'Lusitania': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Mauretania Tingitana': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Baetica': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Tarraconensis': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Aquitania': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Lugdunensis': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Mauretania Caesariensis': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Numidia': {
      4: [-5, -10],
      5: [-15, -30],
      6: [-30, -60],
      7: [-60, -120]
    },
    'Creta et Cyrene': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Alpes Graiae et Poeninae': {
      4: [-999, -999],
      5: [-999, -999],
      6: [-20, -60],
      7: [-40, -120]
    },
    'Alpes Cottiae': {
      4: [-999, -999],
      5: [-999, -999],
      6: [-10, -20],
      7: [-20, -40]
    },
    'Alpes Maritimae': {
      4: [-999, -999],
      5: [-999, -999],
      6: [-20, 10],
      7: [-40, 20]
    },
    'Narbonensis': {
      4: [-10, 5],
      5: [-30, 10],
      6: [-60, 20],
      7: [-120, 40]
    },
    'Raetia': {
      4: [0, -15],
      5: [0, -30],
      6: [0, -60],
      7: [0, -120]
    },
    'Germania Superior': {
      4: [0, 10],
      5: [0, 20],
      6: [0, 40],
      7: [0, 80]
    },
    'Pannonia Superior': {
      4: [5, -10],
      5: [10, -20],
      6: [20, -40],
      7: [40, -80]
    },
    'Pannonia Inferior': {
      4: [0, 10],
      5: [0, 20],
      6: [0, 40],
      7: [0, 80]
    },
    'Dacia': {
      4: [-10, 0],
      5: [-20, 0],
      6: [-40, 0],
      7: [-80, 0]
    },
    'Moesia Superior': {
      4: [-10, -10],
      5: [-20, -20],
      6: [-40, -40],
      7: [-80, -80]
    },
    'Macedonia': {
      4: [-10, 0],
      5: [-20, 0],
      6: [-40, 0],
      7: [-80, 0]
    },
    'Asia': {
      4: [0, -15],
      5: [0, -30],
      6: [0, -60],
      7: [0, -120]
    },
    'Bithynia et Pontus': {
      4: [-10, -10],
      5: [-30, -30],
      6: [-60, -60],
      7: [-120, -120]
    },
    'Galatia et Cappadocia': {
      4: [0, -10],
      5: [0, -30],
      6: [0, -60],
      7: [0, -120]
    },
    'Lycia et Pamphylia': {
      4: [-5, -5],
      5: [-10, -10],
      6: [-20, -20],
      7: [-40, -40]
    },
    'Cilicia': {
      4: [-5, -5],
      5: [-10, -10],
      6: [-20, -20],
      7: [-40, -40]
    },
    'Cyprus': {
      4: [-10, 0],
      5: [-20, 0],
      6: [-40, 0],
      7: [-80, 0]
    },
    'Syria': {
      4: [0, 0],
      5: [-10, 0],
      6: [-20, 0],
      7: [-40, 0]
    },
    'Arabia': {
      4: [0, 0],
      5: [-10, 0],
      6: [-20, 0],
      7: [-40, 0]
    },
    'Aegyptus': {
      4: [0, -30],
      5: [0, -60],
      6: [0, -120],
      7: [0, -240]
    },
    'Germania Inferior': {
      4: [0, -10],
      5: [0, -30],
      6: [0, -60],
      7: [0, -120]
    },
    'Mediolanum': {
      4: [-5, -5],
      5: [-10, -10],
      6: [-20, -20],
      7: [-40, -40]
    },
    'Ariminium': {
      4: [0, -10],
      5: [0, -20],
      6: [0, -40],
      7: [0, -80]
    },
    'Arretium': {
      4: [-10, 0],
      5: [-20, 0],
      6: [-40, 0],
      7: [-80, 0]
    }
  };

  // Map
  $.getJSON('https://cdn.jsdelivr.net/gh/klokantech/roman-empire@master/data/provinces.geojson', function(data) {
    var provincesLayer = L.geoJSON(data, {
      style: function(feature) {
        return { color: getProvinceColor(feature.properties.name) };
      },
      onEachFeature: function(feature, layer) {
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
            html: '<img class="army-icon" src="https://img.icons8.com/external-others-pike-picture/256/external-Legionary-rome-others-pike-picture.png"/><div class="army-number" style="position:absolute; top: 32px; left:22px;">3</div>',
            iconSize: [45, 28],
            iconAnchor: [15, 35]
          });
          var armyMarker = L.marker(layer.getBounds().getCenter(), {
            icon: armyIcon
          }).addTo(map);
        }
      }
    }).addTo(map);
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
