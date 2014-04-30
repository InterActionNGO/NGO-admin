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
  'views/clusters',
  'views/map',
  'views/filters',
  'views/menu-fixed'
], function(ClustersView, MapView, FiltersView, MenuFixedView) {

  new ClustersView();
  new MapView();
  new FiltersView();
  new MenuFixedView();

});


