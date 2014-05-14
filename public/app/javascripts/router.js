'use strict';

define([
  'backbone',

  'models/report',

  'views/report/form',
  'views/report/totals',

  'views/clusters',
  'views/map',
  'views/filters',
  'views/menu-fixed',
  'views/downloads',
  'views/embed-map',
  'views/search',
  'views/layer-overlay',
  'views/timeline'
], function(Backbone, ReportModel) {

  var ReportFormView = arguments[2],
    TotalsView = arguments[3],
    ClustersView = arguments[4],
    MapView = arguments[5],
    FiltersView = arguments[6],
    MenuFixedView = arguments[7],
    DownloadsView = arguments[8],
    EmbedMapView = arguments[9],
    SearchView = arguments[10],
    LayerOverlayView = arguments[11],
    TimelineView = arguments[12];

  var Router = Backbone.Router.extend({

    routes: {
      '': 'lists',
      'sectors/:id': 'lists',
      'organizations/:id': 'lists',
      'donors/:id': 'lists',
      'projects/:id': 'project',
      'search': 'search',
      'p/analysis': 'report'
    },

    initialize: function() {
      Backbone.history.start({
        pushState: true
      });
    },

    lists: function() {
      new ClustersView();
      new MapView();
      new FiltersView();
      new MenuFixedView();
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

    report: function() {
      var reportModel = new ReportModel();

      new ReportFormView({
        model: reportModel
      });

      new TotalsView({
        model: reportModel
      });
    }

  });

  return Router;

});
