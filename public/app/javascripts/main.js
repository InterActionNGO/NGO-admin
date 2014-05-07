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
  'views/menu-fixed'
], function(Routes, ClustersView, MapView, FiltersView, MenuFixedView) {


  new Routes();
  new ClustersView();
  new MapView();
  new FiltersView();
  new MenuFixedView();

  function addClassToBody(){
    var newClass, position;

    position = window.location.pathname.split('/').length - 1;
    newClass = window.location.pathname.split('/')[position];

    $('body').addClass(newClass);
  }

  function goTo(e) {
    var whereToGo = $($(e.currentTarget).attr('href')).offset().top;
    $('body, html').animate({scrollTop: whereToGo - 60}, 500);
    e.preventDefault();
  }

  $('.click-to-see-btn').on('click', goTo);


   addClassToBody();

});


