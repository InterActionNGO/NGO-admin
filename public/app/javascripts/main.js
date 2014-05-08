'use strict';

require.config({

  baseUrl: '/app/javascripts',

  paths: {
    sprintf: '../vendor/sprintf/src/sprintf',
    quicksilver: '../lib/liveupdate/quicksilver',
    liveupdate: '../lib/liveupdate/jquery.liveupdate'
  },

  shim: {
    sprintf: {
      exports: 'sprintf'
    },
    liveupdate: {
      deps: ['quicksilver'],
      exports: '$'
    }
  }

});

require([
  'routes',
  'views/clusters',
  'views/map',
  'views/filters',
  'views/menu-fixed',
  'views/downloads',
  'views/embed-map'
], function(Routes, ClustersView, MapView, FiltersView, MenuFixedView, DownloadsView, EmbedMapView) {

  new Routes();
  new ClustersView();
  new MapView();
  new FiltersView();
  new MenuFixedView();
  new DownloadsView();
  new EmbedMapView();

  var goToNormal;

  function fixCategoriesSelector() {
    var categoriesSelector = $('.categories-selector'),
        menu = $('.mod-categories-selector .menu'),
        scrollTop     = $(window).scrollTop(),
        elementOffset = categoriesSelector.offset().top,
        distance      = (elementOffset - scrollTop);

    console.log(distance);
    console.log(goToNormal + 'goToNormal');

    if (distance  === 1 ) {
      goToNormal = scrollTop;
      categoriesSelector.addClass('is-fixed');
      menu.removeClass('mod-go-up-menu');
      menu.addClass('mod-drop-down-menu');

    } else if (scrollTop < goToNormal) {
      console.log('hola');
      categoriesSelector.removeClass('is-fixed');
      menu.addClass('mod-go-up-menu');
      menu.removeClass('mod-drop-down-menu');
    }
  }

  function addClassToBody() {
    var newClass, position;

    position = window.location.pathname.split('/').length - 1;
    newClass = window.location.pathname.split('/')[position];

    $('body').addClass(newClass);
  }

  function goTo(e) {
    $('body, html').animate({
      scrollTop: $('.layout-content').offset().top - 110
    }, 500);
    e.preventDefault();
  }

  $('.click-to-see-btn').on('click', goTo);

  addClassToBody();
  window.onscroll = fixCategoriesSelector;

});
