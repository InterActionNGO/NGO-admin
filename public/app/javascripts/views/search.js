'use strict';

define(function() {

  var SearchView = Backbone.View.extend({

    el: '#searchView',

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }
    }

  });

  return SearchView;

});
