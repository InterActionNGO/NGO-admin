'use strict';

define([
  'views/clusters',
  'views/map',
  'views/filters'
], function(ClustersView, MapView, FiltersView) {

  var Router;

  new ClustersView();
  new MapView();
  new FiltersView();

  Router = Backbone.Router.extend({});

  return Router;

});
