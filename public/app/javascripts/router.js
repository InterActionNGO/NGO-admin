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
  'views/spin',
  'views/donors-sidebar',
  'views/gallery'
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
    SpinView = arguments[13],
    DonorsSidebarView = arguments[14],
    GalleryView = arguments[15];

  var Router = Backbone.Router.extend({

    routes: {
      '': 'lists',
      'sectors/:id': 'lists',
      'sectors/:id/*params': 'lists',
      'organizations/:id': 'lists',
      'organizations/:id/*params': 'lists',
      'donors/:id': 'lists',
      'donors/:id/*params': 'lists',
      'location/:id': 'lists',
      'location/:id/*params': 'lists',
      'projects/:id': 'project',
      'projects/:id/*params': 'project',
      'location/:region/:id': 'lists',
      'location/:region/:id/*regions': 'lists',
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
      new DonorsSidebarView();
    },

    project: function() {
      this.lists();
      new TimelineView();
      new GalleryView();
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

      $('#faqAccordion').accordion({
        heightStyle: 'content'
      });
    }

  });

  return Router;

});
