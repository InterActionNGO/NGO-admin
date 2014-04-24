'use strict';

define([
  'views/clusters',
  'views/map'
], function(ClustersView, MapView) {

  var app = {}, Router;

  new ClustersView();
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
