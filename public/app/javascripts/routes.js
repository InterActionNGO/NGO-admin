'use strict';

define([
  'views/search'
], function($, SearchView) {

  var Routes = Backbone.Router.extend({

    routes: {
      'search': 'search'
    },

    initialize: function() {
      Backbone.history.start({
        pushState: true
      });
    },

    search: function() {
      new SearchView();
    }

  });

  return Routes;

});
