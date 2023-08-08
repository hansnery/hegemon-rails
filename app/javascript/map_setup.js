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