'use strict';

define([
  'views/clusters',
  'views/map'
], function(ClustersView, MapView) {

  var Router;

  new ClustersView();
  new MapView();

  Router = Backbone.Router.extend({

    routes: {},

    initialize: function() {
      Backbone.history.start({
        pushState: true
      });
    }

  });

  return Router;

});
