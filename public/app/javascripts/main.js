'use strict';

require.config({

  baseUrl: '/app/javascripts',

  paths: {
    sprintf: '../vendor/sprintf/src/sprintf',
  },

  shim: {
    sprintf: {
      exports: 'sprintf'
    }
  }

});

require([
  'router'
], function(Router) {

  new Router();

});
