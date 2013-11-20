var global_index = 10;

(function() {

  var latlng, zoom, mapOptions, map, vizjson;

  if (map_type === 'overview_map' || map_type === 'project_map') {
    latlng = new google.maps.LatLng(map_center[0], map_center[1]);
    zoom = map_zoom;
  } else {
    latlng = new google.maps.LatLng(0, 0);
    zoom = 1;
  }

  mapOptions = {
    zoom: zoom,
    center: latlng,
    scrollwheel: false,
    zoomControlOptions: {
      style: google.maps.ZoomControlStyle.SMALL
    },
    panControl: false,
    scaleControl: false,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
  };

  map = new google.maps.Map(document.getElementById('map'), mapOptions);

  vizjson = {
    "type": "layergroup",
    "options": {
      "user_name": "simbiotica",
      "tiler_protocol": "http",
      "tiler_domain": "cartodb.com",
      "tiler_port": "80",
      "sql_api_protocol": "http",
      "sql_api_domain": "cartodb.com",
      "sql_api_endpoint": "/api/v1/sql",
      "sql_api_port": 80,
      "cdn_url": {
        "http": "api.cartocdn.com",
        "https": "cartocdn.global.ssl.fastly.net"
      },
      "layer_definition": {
        "stat_tag": "d3748996-5139-11e3-93eb-3085a9a9563c",
        "version": "1.0.1",
        "layers": [{
          "id": 61080,
          "type": "CartoDB",
          "infowindow": {
            "fields": [{
              "name": "adm0_a3",
              "title": true,
              "position": 2
            }, {
              "name": "adm0_a3_us",
              "title": true,
              "position": 3
            }, {
              "name": "admin",
              "title": true,
              "position": 4
            }, {
              "name": "area_id",
              "title": true,
              "position": 5
            }, {
              "name": "brk_name",
              "title": true,
              "position": 6
            }, {
              "name": "cash_transfers",
              "title": true,
              "position": 7
            }, {
              "name": "continent",
              "title": true,
              "position": 8
            }, {
              "name": "continent_cartodb_id",
              "title": true,
              "position": 9
            }, {
              "name": "continent_id",
              "title": true,
              "position": 10
            }, {
              "name": "featurecla",
              "title": true,
              "position": 11
            }, {
              "name": "formal_en",
              "title": true,
              "position": 12
            }, {
              "name": "formal_fr",
              "title": true,
              "position": 13
            }, {
              "name": "gdp_md_est",
              "title": true,
              "position": 14
            }, {
              "name": "geounit",
              "title": true,
              "position": 15
            }, {
              "name": "gu_a3",
              "title": true,
              "position": 16
            }, {
              "name": "iso_a2",
              "title": true,
              "position": 17
            }, {
              "name": "iso_a3",
              "title": true,
              "position": 18
            }, {
              "name": "iso_n3",
              "title": true,
              "position": 19
            }, {
              "name": "labelrank",
              "title": true,
              "position": 20
            }, {
              "name": "level",
              "title": true,
              "position": 21
            }, {
              "name": "long_len",
              "title": true,
              "position": 22
            }, {
              "name": "name",
              "title": true,
              "position": 23
            }, {
              "name": "name_alt",
              "title": true,
              "position": 24
            }, {
              "name": "name_sort",
              "title": true,
              "position": 25
            }, {
              "name": "note_adm0",
              "title": true,
              "position": 26
            }, {
              "name": "note_brk",
              "title": true,
              "position": 27
            }, {
              "name": "region_un",
              "title": true,
              "position": 28
            }, {
              "name": "region_wb",
              "title": true,
              "position": 29
            }, {
              "name": "sov_a3",
              "title": true,
              "position": 30
            }, {
              "name": "sovereignt",
              "title": true,
              "position": 31
            }, {
              "name": "su_a3",
              "title": true,
              "position": 32
            }, {
              "name": "subregion",
              "title": true,
              "position": 33
            }],
            "template_name": "table/views/infowindow_light",
            "template": "<div class=\"cartodb-popup\">\n  <a href=\"#close\" class=\"cartodb-popup-close-button close\">x</a>\n  <div class=\"cartodb-popup-content-wrapper\">\n    <div class=\"cartodb-popup-content\">\n      {{#content.fields}}\n        {{#title}}<h4>{{title}}</h4>{{/title}}\n        {{#value}}\n          <p {{#type}}class=\"{{ type }}\"{{/type}}>{{{ value }}}</p>\n        {{/value}}\n        {{^value}}\n          <p class=\"empty\">null</p>\n        {{/value}}\n      {{/content.fields}}\n    </div>\n  </div>\n  <div class=\"cartodb-popup-tip-container\"></div>\n</div>\n"
          },
          "legend": {
            "type": "choropleth",
            "show_title": false,
            "title": "",
            "items": [{
              "name": "Left label",
              "value": "17.00",
              "type": "text"
            }, {
              "name": "Right label",
              "value": "668.00",
              "type": "text"
            }, {
              "name": "Color",
              "value": "#FFFFB2",
              "type": "color"
            }, {
              "name": "Color",
              "value": "#FED976",
              "type": "color"
            }, {
              "name": "Color",
              "value": "#FEB24C",
              "type": "color"
            }, {
              "name": "Color",
              "value": "#FD8D3C",
              "type": "color"
            }, {
              "name": "Color",
              "value": "#FC4E2A",
              "type": "color"
            }, {
              "name": "Color",
              "value": "#E31A1C",
              "type": "color"
            }, {
              "name": "Color",
              "value": "#B10026",
              "type": "color"
            }]
          },
          "order": 1,
          "options": {
            "sql": "select * from countries",
            "layer_name": "countries",
            "cartocss": "/** choropleth visualization */\n\n#countries{\n  line-color: #FFF;\n  line-opacity: 1;\n  line-width: 1;\n  polygon-opacity: 0.8;\n}\n#countries [ cash_transfers <= 668.0] {\n   polygon-fill: #B10026;\n}\n#countries [ cash_transfers <= 213.0] {\n   polygon-fill: #E31A1C;\n}\n#countries [ cash_transfers <= 136.0] {\n   polygon-fill: #FC4E2A;\n}\n#countries [ cash_transfers <= 100.0] {\n   polygon-fill: #FD8D3C;\n}\n#countries [ cash_transfers <= 70.0] {\n   polygon-fill: #FEB24C;\n}\n#countries [ cash_transfers <= 40.0] {\n   polygon-fill: #FED976;\n}\n#countries [ cash_transfers <= 17.0] {\n   polygon-fill: #FFFFB2;\n}",
            "cartocss_version": "2.1.1",
            "interactivity": "cartodb_id"
          }
        }]
      }
    }
  };

  function onWindowLoad() {

    cartodb
      .createLayer(map, vizjson)
      .addTo(map);

    for (var i = 0; i<map_data.length; i++) {
    var image_source = '';

    if(document.URL.indexOf("force_site_id=3")>=0 || document.URL.indexOf("hornofafrica")>=0) {

      if (map_data[i].count < 5) {
        diameter = 20;
        image_source = "/images/themes/"+ theme + '/marker_2.png';
      } else if ((map_data[i].count>=5) && (map_data[i].count<10)) {
        diameter = 26;
        image_source = "/images/themes/"+ theme + '/marker_3.png';
      } else if ((map_data[i].count>=10) && (map_data[i].count<18)) {
        diameter = 34;
        image_source = "/images/themes/"+ theme + '/marker_4.png';
      } else if ((map_data[i].count>=18) && (map_data[i].count<30)) {
        diameter = 42;
        image_source = "/images/themes/"+ theme + '/marker_5.png';
      } else {
        diameter = 58;
        image_source = "/images/themes/"+ theme + '/marker_6.png';
      }
    } else if (map_type == "overview_map") {
      if (map_data[i].count < 25) {
        diameter = 20;
        image_source = "/images/themes/"+ theme + '/marker_2.png';
      } else if ((map_data[i].count>=25) && (map_data[i].count<50)) {
        diameter = 26;
        image_source = "/images/themes/"+ theme + '/marker_3.png';
      } else if ((map_data[i].count>=50) && (map_data[i].count<90)) {
        diameter = 34;
        image_source = "/images/themes/"+ theme + '/marker_4.png';
      } else if ((map_data[i].count>=90) && (map_data[i].count<130)) {
        diameter = 42;
        image_source = "/images/themes/"+ theme + '/marker_5.png';
      } else {
        diameter = 58;
        image_source = "/images/themes/"+ theme + '/marker_6.png';
      }
    } else if (map_type=="administrative_map") {
      if (map_data[i].count < range) {
        diameter = 20;
        image_source = "/images/themes/"+ theme + '/marker_2.png';
      } else if ((map_data[i].count>=range) && (map_data[i].count<(range*2))) {
        diameter = 26;
        image_source = "/images/themes/"+ theme + '/marker_3.png';
      } else if ((map_data[i].count>=(range*2)) && (map_data[i].count<(range*3))) {
        diameter = 34;
        image_source = "/images/themes/"+ theme + '/marker_4.png';
      } else if ((map_data[i].count>=(range*3)) && (map_data[i].count<(range*4))) {
        diameter = 42;
        image_source = "/images/themes/"+ theme + '/marker_5.png';
      } else {
        diameter = 58;
        image_source = "/images/themes/"+ theme + '/marker_6.png';
      }
    } else {
      diameter = 72;
      image_source = "/images/themes/"+ theme + '/project_marker.png';
    }
    var marker_ = new IOMMarker(map_data[i],diameter, image_source,map);

    if (map_type!="overview_map") {
      bounds.extend(new google.maps.LatLng(map_data[i].lat, map_data[i].lon));
    }
  }

  if (map_type!="overview_map") {
    map.fitBounds(bounds);
  }

  if (map_type=="project_map") {
    map.panBy(130,20);
  }

  }

  window.onload = onWindowLoad;

}());