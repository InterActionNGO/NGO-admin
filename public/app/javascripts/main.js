'use strict';

require.config({

  baseUrl: '/app/javascripts'

});

require([
  'router'
], function(Router) {

  new Router();

});
