'use strict';

define([
  'views/map'
], function(MapView) {

  var app = {}, Router;

  app.map = new MapView();

  Router = Backbone.Router.extend({

    routes: {
      'donors/:id': 'donors'
    },

    initialize: function() {
      Backbone.history.start({pushState: true});
    },

    donors: function(id) {
      console.log('donors ' + id);
    }

  });

  return Router;

});
