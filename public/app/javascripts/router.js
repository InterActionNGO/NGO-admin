'use strict';

define([
  'backbone',

  'models/report',

  'views/report-form',
  'views/report-results',

  'views/clusters',
  'views/map',
  'views/filters',
  'views/menu-fixed',
  'views/downloads',
  'views/embed-map',
  'views/search',
  'views/layer-overlay',
  'views/timeline',
  'views/spin'
], function(Backbone, ReportModel) {

  var ReportFormView = arguments[2],
    ReportResultsView = arguments[3],
    ClustersView = arguments[4],
    MapView = arguments[5],
    FiltersView = arguments[6],
    MenuFixedView = arguments[7],
    DownloadsView = arguments[8],
    EmbedMapView = arguments[9],
    SearchView = arguments[10],
    LayerOverlayView = arguments[11],
    TimelineView = arguments[12],
    SpinView = arguments[13];

  var Router = Backbone.Router.extend({

    routes: {
      '': 'lists',
      'sectors/:id': 'lists',
      'organizations/:id': 'lists',
      'donors/:id': 'lists',
      'location/:id': 'lists',
      'projects/:id': 'project',
      'search': 'search',
      'p/:page': 'page'
    },

    initialize: function() {
      var pushState = !!(window.history && window.history.pushState);

      Backbone.history.start({
        pushState: pushState
      });
    },

    lists: function() {
      new ClustersView();
      new MapView();
      new FiltersView();
      new DownloadsView();
      new EmbedMapView();
      new LayerOverlayView();
    },

    project: function() {
      this.lists();
      new TimelineView();
    },

    search: function() {
      new SearchView();
    },

    page: function(page) {
      new MenuFixedView();

      if (page === 'analysis') {
        var reportModel = new ReportModel();

        new SpinView();

        new ReportFormView({
          model: reportModel
        });

        new ReportResultsView({
          model: reportModel
        });
      }
    }

  });

  return Router;

});
