  var mapChartType;
  var map;
  var bounds;
  var overlay;
  var map;
  var baseUrl="http://chart.apis.google.com/chart?chs=256x256";
  var global_index = 10;
  var marker_;

  $(document).ready( function() {
    var styleMapType = new google.maps.StyledMapType(stylez, styledMapOptions);

    var mapChartOptions = {
        getTileUrl: function(coord, zoom) {
            var lULP = new google.maps.Point(coord.x*256,(coord.y+1)*256);
            var lLRP = new google.maps.Point((coord.x+1)*256,coord.y*256);
            var projectionMap = new MercatorProjection();
            var lULg = projectionMap.fromDivPixelToLatLng(lULP, zoom);
            var lLRg = projectionMap.fromDivPixelToLatLng(lLRP, zoom);
            return baseUrl+"&chd="+chd+"&chco="+chco+"&chld="+chld+"&chf="+chf+"&cht=map:fixed="+
               lULg.lat() +","+ lULg.lng() + "," + lLRg.lat() + "," + lLRg.lng();
        },
        tileSize: new google.maps.Size(256, 256),
        opacity:parseFloat(0.4),
        isPng: true
    };
    mapChartType = new google.maps.ImageMapType(mapChartOptions);
    bounds = new google.maps.LatLngBounds();

    if (map_type=="overview_map" || map_type=="project_map") {
      var latlng = new google.maps.LatLng(map_center[0],map_center[1]);
      var zoom = map_zoom;
    } else {
      var latlng = new google.maps.LatLng(0,0);
      var zoom = 1;
    }

    var myOptions = {
      scrollwheel: false,
      mapTypeControl: false,
      streetViewControl: false,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      disableDefaultUI: true,
      zoom: zoom,
      center: latlng
    }
    if ($('#map').length>0) {
      map = new google.maps.Map(document.getElementById("map"), myOptions);
    } else {
      map = new google.maps.Map(document.getElementById("small_map"), myOptions);
    }
    //map.overlayMapTypes.insertAt(2, mapChartType);
    map.mapTypes.set('labels', styleMapType);
    map.setMapTypeId('labels');

    google.maps.event.addListener(map, "zoom_changed", function() {
        if (map.getZoom() > 12) map.setZoom(12);
    });

    if (map_type == "administrative_map") {
      var range = max_count/5;
    }
    var diameter = 0;

	for (var i = 0; i<map_data.length; i++) {
	  var image_source = '';

	  if(document.URL.indexOf("force_site_id=3")>=0 || document.URL.indexOf("hornofafrica")>=0) {
		if (map_type == "overview_map") {
			//map.overlayMapTypes.insertAt(2, mapChartType);
		}
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

    // for (var i = 0; i<map_data.length; i++) {
    //   var image_source = '';
    //
    //   console.log(map_data);
    //
    //   if (map_type == "overview_map") {
    //     if (map_data[i].count < 25) {
    //       diameter = 20;
    //       image_source = "/images/themes/"+ theme + '/marker_2.png';
    //     } else if ((map_data[i].count>=25) && (map_data[i].count<50)) {
    //       diameter = 26;
    //       image_source = "/images/themes/"+ theme + '/marker_3.png';
    //     } else if ((map_data[i].count>=50) && (map_data[i].count<90)) {
    //       diameter = 34;
    //       image_source = "/images/themes/"+ theme + '/marker_4.png';
    //     } else if ((map_data[i].count>=90) && (map_data[i].count<130)) {
    //       diameter = 42;
    //       image_source = "/images/themes/"+ theme + '/marker_5.png';
    //     } else {
    //       diameter = 58;
    //       image_source = "/images/themes/"+ theme + '/marker_6.png';
    //     }
    //   } else if (map_type=="administrative_map") {
    //     if (map_data[i].count < range) {
    //       diameter = 20;
    //       image_source = "/images/themes/"+ theme + '/marker_2.png';
    //     } else if ((map_data[i].count>=range) && (map_data[i].count<(range*2))) {
    //       diameter = 26;
    //       image_source = "/images/themes/"+ theme + '/marker_3.png';
    //     } else if ((map_data[i].count>=(range*2)) && (map_data[i].count<(range*3))) {
    //       diameter = 34;
    //       image_source = "/images/themes/"+ theme + '/marker_4.png';
    //     } else if ((map_data[i].count>=(range*3)) && (map_data[i].count<(range*4))) {
    //       diameter = 42;
    //       image_source = "/images/themes/"+ theme + '/marker_5.png';
    //     } else {
    //       diameter = 58;
    //       image_source = "/images/themes/"+ theme + '/marker_6.png';
    //     }
    //   } else {
    //     diameter = 72;
    //     image_source = "/images/themes/"+ theme + '/project_marker.png';
    //   }
    //   marker_ = new IOMMarker(map_data[i],diameter, image_source,map);
    //
    //   if (map_type!="overview_map") {
    //     bounds.extend(new google.maps.LatLng(map_data[i].lat, map_data[i].lon));
    //   }
    // }
    //
    // if (map_type!="overview_map") {
    //   map.fitBounds(bounds);
    // }

    // if (map_type=="project_map") {
    //   map.panBy(130,20);
    // }

    //Positionate zoom controls
    setTimeout(function(){
      positionControls();
      $('#zoomIn').fadeIn();
      $('#zoomOut').fadeIn();
      $('div.map_style').fadeIn();
    },500);

    $('#zoomIn,#zoomOut').click(function(ev){
      ev.preventDefault();
      ev.stopPropagation();
    });



    $('div.map_style').click(function(){
      if ($('div.map_style').height()==76) {
        $('div.map_style').css('background-position','0 0');
        $('div.map_style').height(26);
      } else {
        $('div.map_style').css('background-position','0 -26px');
        $('div.map_style').height(76);
      }
    });

    $('div.map_style ul li a').click(function(ev){
      ev.preventDefault();
      ev.stopPropagation();
      if ($(this).text()!=$('div.map_style').text()) {
        if ($(this).text()=="PLAIN") {
          map.setMapTypeId('labels');
        } else {
          map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
        }
        $('div.map_style p').text($(this).text());
      }
      $('div.map_style').css('background-position','0 0');
      $('div.map_style').height(26);
    });


    $(window).resize(function() {
      positionControls();
    });

  });


  function positionControls() {
    try{
      var header_height = 0;
      if ($('#layout').length>0) {
        var column_position = $('#layout').offset().left;
        var map_position = $('#map').position().top + 25;
        var column_height = $('.float_head').outerHeight();
      } else {
        var column_position = $('#mesh').offset().left + 5;
        var map_position = $('#small_map').position().top + 25;
        var column_height = $('.float_head').outerHeight();
      }

      if ($('#outer_layout #header').length == 0){
        var header_height = $('#header').outerHeight();
      }

      $('#zoomIn').css('left', column_position+'px');
      $('#zoomIn').css('top', column_height + header_height + 25);

      $('#zoomOut').css('left', column_position+32+'px');
      $('#zoomOut').css('top', column_height + header_height + 25);

      $('div.map_style').css('left',column_position+821+'px');
      $('div.map_style').css('top',map_position+'px');
    }
    catch(e){
    }
  }


  function zoomIn() {
    var zoom = map.getZoom();
    if (zoom<12) {
      map.setZoom(zoom+1);
    }
  }

  function zoomOut() {
    map.setZoom(map.getZoom() - 1);
  }
