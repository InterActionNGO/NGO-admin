/*global google,map_type,map_data:true,map_center,sprintf,kind,theme,map_zoom,MAP_EMBED,show_regions_with_one_project,max_count,empty_layer*/
'use strict';

define(function() {

  function old() {

    function IOMMarker(info, diameter, image, map) {
      // this.latlng_ = new google.maps.LatLng(info.lat,info.lon);
      this.latlng_ = new google.maps.LatLng(parseFloat(info.lat), parseFloat(info.lon));
      this.url = info.url;
      this.count = info.count;
      this.total_in_region = info.total_in_region;
      this.image = image;
      this.map_ = map;
      this.name = info.name;
      this.diameter = diameter;


      this.offsetVertical_ = -(this.diameter / 2);
      this.offsetHorizontal_ = -(this.diameter / 2);
      this.height_ = this.diameter;
      this.width_ = this.diameter;

      this.setMap(map);
    }

    IOMMarker.prototype = new google.maps.OverlayView();

    IOMMarker.prototype.draw = function() {

      var me = this;

      var div = this.div_;
      if (!div) {
        div = this.div_ = document.createElement('div');
        div.style.border = 'none';
        div.style.position = 'absolute';
        div.style.width = this.diameter + 'px';
        div.style.height = this.diameter + 'px';
        div.style.zIndex = 1;
        div.style.cursor = 'pointer';

        //Marker image
        var marker_image = document.createElement('img');
        marker_image.style.position = 'relative';
        marker_image.style.width = '100%';
        marker_image.style.height = '100%';
        marker_image.src = this.image;
        div.appendChild(marker_image);

        try {
          if (show_regions_with_one_project !== undefined) {
            var count = document.createElement('p');
            count.style.position = 'absolute';
            count.style.top = '50%';
            count.style.left = '50%';
            count.style.height = '15px';
            count.style.textAlign = 'center';
            if (this.diameter === 20) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 10px Arial';
            } else if (this.diameter === 26) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 11px Arial';
            } else if (this.diameter === 34) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 12px Arial';
            } else if (this.diameter === 42) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 15px Arial';
            } else {
              count.style.margin = '-9px 0 0 0px';
              count.style.font = 'normal 18px Arial';
            }
            count.style.color = 'white';
            $(count).text(this.count);
            div.appendChild(count);
          }
        } catch (e) {
          if (this.count > 1) {
            var count = document.createElement('p');
            count.style.position = 'absolute';
            count.style.top = '50%';
            count.style.left = '50%';
            count.style.height = '15px';
            count.style.textAlign = 'center';
            if (this.diameter === 20) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 10px Arial';
            } else if (this.diameter === 26) {
              count.style.margin = '-6px 0 0 0px';
              count.style.font = 'normal 11px Arial';
            } else if (this.diameter === 34) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 12px Arial';
            } else if (this.diameter === 42) {
              count.style.margin = '-7px 0 0 0px';
              count.style.font = 'normal 15px Arial';
            } else {
              count.style.margin = '-9px 0 0 0px';
              count.style.font = 'normal 18px Arial';
            }
            count.style.color = 'white';
            $(count).text(this.count);
            div.appendChild(count);
          }
        }

        //Marker address
        if (map_type === 'overview_map' || map_type === 'administrative_map') {

          var hidden_div = document.createElement('div');
          hidden_div.style.border = 'none';
          hidden_div.style.position = 'absolute';
          hidden_div.style.margin = '0px';
          hidden_div.style.padding = '0px';
          hidden_div.style.display = 'none';
          hidden_div.style.bottom = this.diameter + 4 + 'px';
          hidden_div.style.left = (this.diameter / 2) - (175 / 2) + 'px';
          hidden_div.style.width = '175px';

          try {
            if (kind !== null) {
              var top_hidden = document.createElement('div');
              top_hidden.style.border = 'none';
              top_hidden.style.position = 'relative';
              top_hidden.style.float = 'left';
              top_hidden.style.padding = '9px 15px 3px 11px';
              top_hidden.style.width = '149px';
              top_hidden.style.height = 'auto';
              top_hidden.style.background = 'url("/app/images/sites/common/tooltips/body_tooltip.png") no-repeat center top';
              top_hidden.style.font = 'bold 17px "PT Sans"';
              top_hidden.style.textAlign = 'center';
              top_hidden.style.color = 'white';
              if (kind === 'sector' || kind === 'cluster') {
                $(top_hidden).html(this.name + '<br/><strong style="font:normal 13px Arial; color:#dddddd">' + this.count + ((this.count > 1) ? ' projects in this ' + kind : ' project in this ' + kind) + '</strong><br/><strong style="font:normal 12px Arial; color:#999999">' + this.total_in_region + ' in total</strong>');
              } else {
                $(top_hidden).html(this.name + '<br/><strong style="font:normal 13px Arial; color:#dddddd">' + this.count + ((this.count > 1) ? ' projects by this ' + kind : ' project by this ' + kind) + '</strong><br/><strong style="font:normal 12px Arial; color:#999999">' + this.total_in_region + ' in total</strong>');
              }
              hidden_div.appendChild(top_hidden);
            }
          } catch (e) {
            var top_hidden = document.createElement('div');
            top_hidden.style.border = 'none';
            top_hidden.style.position = 'relative';
            top_hidden.style.float = 'left';
            top_hidden.style.padding = '9px 15px 3px 11px';
            top_hidden.style.width = '149px';
            top_hidden.style.height = 'auto';
            top_hidden.style.background = 'url("/app/images/sites/common/tooltips/body_tooltip.png") no-repeat center top';
            top_hidden.style.font = 'bold 17px "PT Sans"';
            top_hidden.style.textAlign = 'center';
            top_hidden.style.color = 'white';
            $(top_hidden).html(this.name + '<br/><strong style="font:normal 13px Arial; color:#999999">' + this.count + ((this.count > 1) ? ' projects' : ' project') + '</strong>');
            hidden_div.appendChild(top_hidden);
          }


          var bottom_hidden = document.createElement('div');
          bottom_hidden.style.border = 'none';
          bottom_hidden.style.position = 'relative';
          bottom_hidden.style.float = 'left';
          bottom_hidden.style.background = 'url("/app/images/sites/common/tooltips/bottom_tooltip.png") no-repeat 0 0';
          bottom_hidden.style.width = '175px';
          bottom_hidden.style.height = '14px';
          hidden_div.appendChild(bottom_hidden);

          div.appendChild(hidden_div);

          google.maps.event.addDomListener(div, 'mouseover', function() {
            $(this).css('zIndex', global_index++);
            $(this).children('div').show();
          });

          google.maps.event.addDomListener(div, 'mouseout', function() {
            $(this).children('div').hide();
          });
        } else {
          google.maps.event.addDomListener(div, 'mouseover', function() {
            $(this).css('zIndex', global_index++);
          });
        }



        google.maps.event.addDomListener(div, 'click', function(ev) {
          try {
            ev.stopPropagation();
          } catch (e) {
            event.cancelBubble = true;
          }

          if (me.url !== undefined && me.url !== window.location.pathname + window.location.search) {

            if (typeof MAP_EMBED !== 'undefined' && MAP_EMBED) {
              window.open(
                me.url,
                '_blank'
              );
            } else {
              window.location.href = me.url;
            }
          } else {
            $('html,body').animate({
              scrollTop: $('#projects_div').offset().top
            }, 1000);
          }
        });


        google.maps.event.addDomListener(div, 'mousedown', function(ev) {
          try {
            ev.stopPropagation();
          } catch (e) {
            event.cancelBubble = true;
          }
        });



        var panes = this.getPanes();
        panes.floatPane.appendChild(div);


        if (($(this.div_).children('p').width() + 6) > this.width_) {
          $(this.div_).children('p').css('display', 'none');
        } else {
          $(this.div_).children('p').css('margin-left', -($(this.div_).children('p').width() / 2) + 'px');
        }

      }

      var pixPosition = me.getProjection().fromLatLngToDivPixel(me.latlng_);
      if (pixPosition) {
        div.style.width = me.width_ + 'px';
        div.style.left = (pixPosition.x + me.offsetHorizontal_) + 'px';
        div.style.height = me.height_ + 'px';
        div.style.top = (pixPosition.y + me.offsetVertical_) + 'px';
      }

    };

    IOMMarker.prototype.remove = function() {
      if (this.div_) {
        this.div_.parentNode.removeChild(this.div_);
        this.div_ = null;
      }
    };

    IOMMarker.prototype.hide = function() {
      if (this.div_) {
        $(this.div_).find('div').fadeOut();
      }
    };


    var global_index = 10;
    var $overlay;
    var $contentOverlay;

    /**
     * @constructor
     * @implements {google.maps.MapType}
     */
    function EmptyMapType() {}

    EmptyMapType.prototype.tileSize = new google.maps.Size(256, 256);
    EmptyMapType.prototype.maxZoom = 19;

    EmptyMapType.prototype.getTile = function(coord, zoom, ownerDocument) {
      var div = ownerDocument.createElement('div');
      div.style.width = this.tileSize.width + 'px';
      div.style.height = this.tileSize.height + 'px';
      div.style.fontSize = '10';
      div.style.borderWidth = '0';
      div.style.backgroundColor = '#91abcd';
      return div;
    };

    EmptyMapType.prototype.name = 'Void';
    EmptyMapType.prototype.alt = 'A empty tile';

    var emptyMapType = new EmptyMapType();

    var latlng, zoom, mapOptions, cartodbOptions, map, bounds, cartoDBLayer, currentLayer, $layerSelector, legends, $legendWrapper, $mapTypeSelector, layerActive;

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
      scrollwheel: false,
      disableDefaultUI: true,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      mapTypeControlOptions: {
        mapTypeIds: ['EMPTY', google.maps.MapTypeId.ROADMAP]
      }
    };

    cartodbOptions = {
      user_name: 'ngoaidmap',
      type: 'cartodb',
      cartodb_logo: false,
      legends: false,
      sublayers: [{
        sql: 'SELECT * from ne_10m_admin_0_countries',
        cartocss: '#table{}'
      }]
    };

    legends = {
      red: {
        left: '0%',
        right: '100%',
        colors: ['#ffffb2', '#fed976', '#feb24c', '#fd8d3c', '#fc4e2a', '#e31a1c', '#b10026']
      },
      blue: {
        left: '0%',
        right: '100%',
        colors: ['#f0f9e8', '#ccebc5', '#a8ddb5', '#7bccc4', '#4eb3d3', '#2b8cbe', '#08589e']
      },
      green: {
        left: '0%',
        right: '100%',
        colors: ['#edf8fb', '#ccece6', '#99d8c9', '#66c2a4', '#41ae76', '#238b45', '#005824']
      }
    };

    bounds = new google.maps.LatLngBounds();

    var sublayer;

    function onSelectLayer(e) {
      var $el = $(e.currentTarget);
      var $emptyLayer = $('#emptyLayer');

      var currentTable = $el.data('table');
      //var currentSQL = $el.data('sql');
      var currentMin = $el.data('min');
      var currentMax = $el.data('max');
      var currentUnits = $el.data('units');
      var layerStyle = $el.data('style');
      var currentDiff = currentMax + currentMin;

      $legendWrapper.html('');

      if ($el.data('layer') === 'none') {
        sublayer = currentLayer.getSubLayer(0);
        sublayer.setSQL('SELECT * from ne_10m_admin_0_countries');
        sublayer.setCartoCSS('#table{}');
      }

      if (window.sessionStorage) {
        window.sessionStorage.setItem('layer', $el.attr('id'));
      }

      layerActive = false;

      if (currentTable) {

        var currentLegend;

        switch (layerStyle) {
          case 'yellow-to-red':
            currentLegend = legends.red;
            break;
          case 'light-to-green':
            currentLegend = legends.green;
            break;
          case 'yellow-to-blue':
            currentLegend = legends.blue;
            break;
          default:
            currentLegend = legends.red;
        }

        console.log(layerStyle);

        var currentCSS = sprintf('#%1$s{line-color: #ffffff; line-opacity: 1; line-width: 1; polygon-opacity: 0.8;}', currentTable);
        var c_len = currentLegend.colors.length;

        _.each(currentLegend.colors, function(c, i) {
          currentCSS = currentCSS + sprintf(' #%1$s [data <= %3$s] {polygon-fill: %2$s;}', currentTable, currentLegend.colors[c_len - i - 1], (((currentDiff / c_len) * (c_len - i)) - currentMin).toFixed(1));
        });

        console.log(currentCSS);

        var choroplethLegend = new cdb.geo.ui.Legend.Choropleth(_.extend(currentLegend, {
          title: $el.data('layer'),
          left: currentMin + currentUnits,
          right: currentMax + currentUnits
        }));
        var stackedLegend = new cdb.geo.ui.Legend.Stacked({
          legends: [choroplethLegend]
        });

        var iconHtml = sprintf('%1$s <a href="#" class="infowindow-pop" data-overlay="%2$s"><span class="icon-info">i</span></a>', $el.data('layer'), $el.data('overlay'));
        var infowindowHtml = sprintf('<div class="cartodb-popup dark"><a href="#close" class="cartodb-popup-close-button close">x</a><div class="cartodb-popup-content-wrapper"><div class="cartodb-popup-content"><h2>{{content.data.country_name}}</h2><p class="infowindow-layer">%s<p><p><span class="infowindow-data">{{#content.data.data}}{{content.data.data}}</span>%s{{/content.data.data}}{{^content.data.data}}No data{{/content.data.data}}</p><p class="data-year">{{content.data.year}}</p></div></div><div class="cartodb-popup-tip-container"></div></div>', iconHtml, $el.data('units'));

        sublayer = currentLayer.getSubLayer(0);

        if (sublayer) {
          sublayer.remove();
        }

        sublayer = currentLayer.createSubLayer({
          sql: 'SELECT ' + currentTable + '.country_name, ' + currentTable + '.code, ' + currentTable + '.year,' + currentTable + '.data, ne_10m_admin_0_countries.the_geom, ne_10m_admin_0_countries.the_geom_webmercator FROM ' + currentTable + ' join ne_10m_admin_0_countries on ' + currentTable + '.code=ne_10m_admin_0_countries.adm0_a3_is',
          cartocss: currentCSS,
          interaction: 'country_name, data, year',
        });

        $('.infowindow-pop').unbind('click');

        var infowindow = cdb.vis.Vis.addInfowindow(map, sublayer, ['country_name', 'data', 'year'], {
          infowindowTemplate: infowindowHtml,
          cursorInteraction: false
        });

        infowindow.model.on('change:visibility', function(model) {
          if (model.get('visibility')) {
            $('.infowindow-pop').click(function(e) {
              e.preventDefault();
              e.stopPropagation();

              var overlayHtml = $($(e.currentTarget).data('overlay')).html();

              $contentOverlay.html(overlayHtml);
              $overlay.fadeIn('fast');
            });
          }
        });

        sublayer.setInteraction(true);

        layerActive = true;

        $legendWrapper.html(stackedLegend.render().$el);
      }

      if (layerActive) {
        if (window.sessionStorage && window.sessionStorage.getItem('type')) {
          $('#' + window.sessionStorage.getItem('type')).trigger('click');
        }
        $emptyLayer.removeClass('hide').find('a').trigger('click');
      } else {
        $emptyLayer.addClass('hide').next().find('a').trigger('click');
      }

      $layerSelector.find('.current-selector').html($el.html());
    }

    function onWindowLoad() {
      var range;

      if (empty_layer) {
        window.sessionStorage.setItem('layer', '');
      }

      $overlay = $('#overlay');
      $contentOverlay = $('#contentOverlay');

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
        map = new google.maps.Map(document.getElementById('small_map'), mapOptions);
      }

      map.mapTypes.set('EMPTY', emptyMapType);

      google.maps.event.addListener(map, 'zoom_changed', function() {
        if (map.getZoom() > 12) {
          map.setZoom(12);
        }
      });

      if (map_type !== 'administrative_map') {
        range = max_count / 5;
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
        if (window.sessionStorage && window.sessionStorage.getItem('layer')) {
          $('#' + window.sessionStorage.getItem('layer')).trigger('click');
        }
      }).addTo(map);

      // Markers
      for (var i = 0; i < map_data.length; i++) {
        var image_source = '';

        if (document.URL.indexOf('force_site_id=3') >= 0 || document.URL.indexOf('hornofafrica') >= 0) {

          if (map_data[i].count < 5) {
            diameter = 20;
            image_source = '/app/images/themes/' + theme + '/marker_2.png';
          } else if ((map_data[i].count >= 5) && (map_data[i].count < 10)) {
            diameter = 26;
            image_source = '/app/images/themes/' + theme + '/marker_3.png';
          } else if ((map_data[i].count >= 10) && (map_data[i].count < 18)) {
            diameter = 34;
            image_source = '/app/images/themes/' + theme + '/marker_4.png';
          } else if ((map_data[i].count >= 18) && (map_data[i].count < 30)) {
            diameter = 42;
            image_source = '/app/images/themes/' + theme + '/marker_5.png';
          } else {
            diameter = 58;
            image_source = '/app/images/themes/' + theme + '/marker_6.png';
          }
        } else if (map_type !== 'overview_map') {
          if (map_data[i].count < 25) {
            diameter = 20;
            image_source = '/app/images/themes/' + theme + '/marker_2.png';
          } else if ((map_data[i].count >= 25) && (map_data[i].count < 50)) {
            diameter = 26;
            image_source = '/app/images/themes/' + theme + '/marker_3.png';
          } else if ((map_data[i].count >= 50) && (map_data[i].count < 90)) {
            diameter = 34;
            image_source = '/app/images/themes/' + theme + '/marker_4.png';
          } else if ((map_data[i].count >= 90) && (map_data[i].count < 130)) {
            diameter = 42;
            image_source = '/app/images/themes/' + theme + '/marker_5.png';
          } else {
            diameter = 58;
            image_source = '/app/images/themes/' + theme + '/marker_6.png';
          }
        } else if (map_type !== 'administrative_map') {
          if (map_data[i].count < range) {
            diameter = 20;
            image_source = '/app/images/themes/' + theme + '/marker_2.png';
          } else if ((map_data[i].count >= range) && (map_data[i].count < (range * 2))) {
            diameter = 26;
            image_source = '/app/images/themes/' + theme + '/marker_3.png';
          } else if ((map_data[i].count >= (range * 2)) && (map_data[i].count < (range * 3))) {
            diameter = 34;
            image_source = '/app/images/themes/' + theme + '/marker_4.png';
          } else if ((map_data[i].count >= (range * 3)) && (map_data[i].count < (range * 4))) {
            diameter = 42;
            image_source = '/app/images/themes/' + theme + '/marker_5.png';
          } else {
            diameter = 58;
            image_source = '/app/images/themes/' + theme + '/marker_6.png';
          }
        } else {
          diameter = 72;
          image_source = '/app/images/themes/' + theme + '/project_marker.png';
        }

        new IOMMarker(map_data[i], diameter, image_source, map);

        if (map_type !== 'overview_map') {
          bounds.extend(new google.maps.LatLng(map_data[i].lat, map_data[i].lon));
        }
      }

      if (map_type !== 'overview_map') {
        map.fitBounds(bounds);

        if (map_data[0].type === 'country') {
          setTimeout(function() {
            map.setZoom(8);
          }, 1000);
        }
      }

      if (map_type === 'project_map') {
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

        var overlayHtml = $($(e.currentTarget).closest('a').data('overlay')).html();

        $contentOverlay.html(overlayHtml);
        $overlay.fadeIn('fast');
      });

      $mapTypeSelector.find('a').click(function(e) {
        e.preventDefault();
        var $current = $(e.currentTarget);
        var type = $current.data('type');
        if (type === 'EMPTY') {
          map.setMapTypeId(type);
        } else {
          map.setMapTypeId(google.maps.MapTypeId[type]);
        }
        $mapTypeSelector.find('.current-selector').text($current.text());
        if (window.sessionStorage) {
          window.sessionStorage.setItem('type', $current.attr('id'));
        }
      });

      var hH = $('.float_head').height();

      if (hH > 170) {
        $('#controlZoom').css('top', hH - 110);
      }

      $('#zoomOut').click(function(e) {
        e.preventDefault();
        map.setZoom(map.getZoom() - 1);
      });

      $('#zoomIn').click(function(e) {
        e.preventDefault();
        map.setZoom(map.getZoom() + 1);
      });

    }

    onWindowLoad();

  }

  var MapView = Backbone.View.extend({

    el: '#mapView',

    initialize: function() {
      var h = $(window).height() -175;
      this.$el.height(h);
      old();
    }

  });

  return MapView;

});
