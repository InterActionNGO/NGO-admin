var global_index = 10;

(function() {

  var latlng, zoom, mapOptions, map, vizjson, bounds, cartoDBLayer, currentLayer, $layerSelector, legends, $legendWrapper, infowindowHtml;

  infowindowHtml = '<div class="cartodb-popup"><a href="#close" class="cartodb-popup-close-button close">x</a><div class="cartodb-popup-content-wrapper"><div class="cartodb-popup-content"><h2>{{content.data.country_name}}</h2><p><strong>Value</strong>: {{content.data.data}}</p><p><strong>Year</strong>: {{content.data.year}}</p></div></div><div class="cartodb-popup-tip-container"></div></div>';

  if (map_type === 'overview_map' || map_type === 'project_map') {
    latlng = new google.maps.LatLng(map_center[0], map_center[1]);
    zoom = map_zoom;
  } else {
    latlng = new google.maps.LatLng(0, 0);
    zoom = 1;
  }

  $layerSelector = $('#layerSelector');
  $mapTypeSelector = $('#mapTypeSelector');
  $legendWrapper = $('#legendWrapper');

  mapOptions = {
    zoom: zoom,
    center: latlng,
    disableDefaultUI: true,
    zoomControl: false,
    scrollwheel: false,
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.SMALL
    },
    panControl: false,
    scaleControl: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
  };

  cartodbOptions = {
    user_name: 'simbiotica',
    type: 'cartodb',
    cartodb_logo: false,
    legends: false,
    sublayers: []
  };

  legends = {
    red: {
      left: "0%",
      right: "100%",
      colors: ['#ffffb2', '#fed976', '#feb24c', '#fd8d3c', '#fc4e2a', '#e31a1c', '#b10026']
    },
    blue: {
      left: "0%",
      right: "100%",
      colors: ['#f0f9e8', '#ccebc5', '#a8ddb5', '#7bccc4', '#4eb3d3', '#2b8cbe', '#08589e']
    },
    green: {
      left: "0%",
      right: "100%",
      colors: ['#edf8fb', '#ccece6', '#99d8c9', '#66c2a4', '#41ae76', '#238b45', '#005824']
    }
  };

  bounds = new google.maps.LatLngBounds();

  function onSelectLayer(e) {
    var $el = $(e.currentTarget);

    var currentTable = $el.data('table');
    var currentSQL = $el.data('sql');
    var currentMin = $el.data('min');
    var currentMax = $el.data('max');
    var currentDiff = currentMax - currentMin;

    var currentLegend;
    switch (theme) {
      case '1':
        currentLegend = legends.red;
        break;
      case '2':
        currentLegend = legends.green;
        break;
      case '3':
        currentLegend = legends.blue;
        break;
      default:
        currentLegend = legends.red;
    }

    var currentCSS = sprintf('#%1$s{line-color: #ffffff; line-opacity: 1; line-width: 1; polygon-opacity: 0.8;}', currentTable);
    var c_len = currentLegend.colors.length;

    _.each(currentLegend.colors, function(c, i) {
      currentCSS = currentCSS + sprintf(' #%1$s [data <= %3$s] {polygon-fill: %2$s;}', currentTable, currentLegend.colors[c_len - i - 1], (((currentDiff / c_len) * (c_len - i)) - currentMin).toFixed(1));
    });

    var choroplethLegend = new cdb.geo.ui.Legend.Choropleth(_.extend(currentLegend, {title: $el.data('layer'), left: currentMin + '%', right: currentMax + '%'}));
    var stackedLegend = new cdb.geo.ui.Legend.Stacked({
      legends: [choroplethLegend]
    });

    if (currentLayer.layers.length > 0) {
      var sublayer = currentLayer.getSubLayer(0);
      sublayer.remove();
    }

    $legendWrapper.html('');

    if (currentSQL) {
      currentLayer.createSubLayer({
        sql: currentSQL,
        cartocss: currentCSS
      });

      var sublayer = currentLayer.getSubLayer(0);

      sublayer.setInteraction(true);

      cdb.vis.Vis.addInfowindow(map, sublayer, ['country_name', 'data', 'year'], {
        infowindowTemplate: infowindowHtml,
        cursorInteraction: true
      });

      $legendWrapper.html(stackedLegend.render().$el);
    }

    $layerSelector.find('.current-selector').text($el.text());
  }

  function onWindowLoad() {

    var $overlay = $('#overlay');
    var $contentOverlay = $('#contentOverlay');

    $layerSelector = $('#layerSelector');
    $mapTypeSelector = $('#mapTypeSelector');
    $legendWrapper = $('#legendWrapper');

    $('#closeOverlay').click(function(e) {
      e.preventDefault();
      $overlay.fadeOut('fast');
    });

    if ($('#map').length > 0) {
      map = new google.maps.Map(document.getElementById('map'), mapOptions);
    } else {
      map = new google.maps.Map(document.getElementById("small_map"), mapOptions);
    }

    google.maps.event.addListener(map, "zoom_changed", function() {
      if (map.getZoom() > 12) map.setZoom(12);
    });

    if (map_type == "administrative_map") {
      var range = max_count / 5;
    }
    var diameter = 0;

    // If region exist, reject a country object
    _.each(map_data, function(d) {
      if (d.type === 'region') {
        map_data = _.reject(map_data, function(d) {
          return d.type === 'country';
        });
        return false;
      }
    });

    // Cartodb
    cartoDBLayer = cartodb.createLayer(map, cartodbOptions);

    cartoDBLayer.on('done', function(layer) {
      currentLayer = layer;
    }).addTo(map);

    // Markers
    for (var i = 0; i < map_data.length; i++) {
      var image_source = '';

      if (document.URL.indexOf("force_site_id=3") >= 0 || document.URL.indexOf("hornofafrica") >= 0) {

        if (map_data[i].count < 5) {
          diameter = 20;
          image_source = "/images/themes/" + theme + '/marker_2.png';
        } else if ((map_data[i].count >= 5) && (map_data[i].count < 10)) {
          diameter = 26;
          image_source = "/images/themes/" + theme + '/marker_3.png';
        } else if ((map_data[i].count >= 10) && (map_data[i].count < 18)) {
          diameter = 34;
          image_source = "/images/themes/" + theme + '/marker_4.png';
        } else if ((map_data[i].count >= 18) && (map_data[i].count < 30)) {
          diameter = 42;
          image_source = "/images/themes/" + theme + '/marker_5.png';
        } else {
          diameter = 58;
          image_source = "/images/themes/" + theme + '/marker_6.png';
        }
      } else if (map_type == "overview_map") {
        if (map_data[i].count < 25) {
          diameter = 20;
          image_source = "/images/themes/" + theme + '/marker_2.png';
        } else if ((map_data[i].count >= 25) && (map_data[i].count < 50)) {
          diameter = 26;
          image_source = "/images/themes/" + theme + '/marker_3.png';
        } else if ((map_data[i].count >= 50) && (map_data[i].count < 90)) {
          diameter = 34;
          image_source = "/images/themes/" + theme + '/marker_4.png';
        } else if ((map_data[i].count >= 90) && (map_data[i].count < 130)) {
          diameter = 42;
          image_source = "/images/themes/" + theme + '/marker_5.png';
        } else {
          diameter = 58;
          image_source = "/images/themes/" + theme + '/marker_6.png';
        }
      } else if (map_type == "administrative_map") {
        if (map_data[i].count < range) {
          diameter = 20;
          image_source = "/images/themes/" + theme + '/marker_2.png';
        } else if ((map_data[i].count >= range) && (map_data[i].count < (range * 2))) {
          diameter = 26;
          image_source = "/images/themes/" + theme + '/marker_3.png';
        } else if ((map_data[i].count >= (range * 2)) && (map_data[i].count < (range * 3))) {
          diameter = 34;
          image_source = "/images/themes/" + theme + '/marker_4.png';
        } else if ((map_data[i].count >= (range * 3)) && (map_data[i].count < (range * 4))) {
          diameter = 42;
          image_source = "/images/themes/" + theme + '/marker_5.png';
        } else {
          diameter = 58;
          image_source = "/images/themes/" + theme + '/marker_6.png';
        }
      } else {
        diameter = 72;
        image_source = "/images/themes/" + theme + '/project_marker.png';
      }
      var marker_ = new IOMMarker(map_data[i], diameter, image_source, map);

      if (map_type != "overview_map") {
        bounds.extend(new google.maps.LatLng(map_data[i].lat, map_data[i].lon));
      }
    }

    if (map_type != "overview_map") {
      map.fitBounds(bounds);

      if (map_data[0].type === 'country') {
        setTimeout(function() {
          map.setZoom(8);
        }, 1000);
      }
    }

    if (map_type == "project_map") {
      map.panBy(130, 20);
    }

    // Layer selector
    $layerSelector.find('a').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      onSelectLayer(e);
    });

    $layerSelector.find('.icon-info').click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      console.log($contentOverlay);
      $contentOverlay.html('<h2>Lorem ipsum</h2><p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Libero, officia, numquam, odio, doloribus molestias velit aspernatur corrupti dicta cupiditate vitae reiciendis veniam iusto minima enim ad obcaecati facere. Commodi, fugit.</p>');
      $overlay.fadeIn('fast');
    });

    $mapTypeSelector.find('a').click(function(e) {
      e.preventDefault();
      var $current = $(e.currentTarget);
      map.setMapTypeId(google.maps.MapTypeId[$current.data('type')]);
      $mapTypeSelector.find('.current-selector').text($current.text());
    });

    $('#zoomOut').click(function(e) {
      e.preventDefault();
      map.setZoom(map.getZoom() - 1);
    });

    $('#zoomIn').click(function(e) {
      e.preventDefault();
      map.setZoom(map.getZoom() + 1);
    });

  }

  $(window).load(onWindowLoad);

}());
