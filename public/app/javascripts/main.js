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
  'router'
], function(Router) {

  new Router();

});


