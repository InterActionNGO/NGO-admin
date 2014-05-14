'use strict';

define(['backbone', 'liveupdate'], function(Backbone) {

  var FiltersView = Backbone.View.extend({

    el: '#filtersView',

    initialize: function() {
      this.$el.find('.organizations input.mod-categories-search')
        .liveUpdate('.organizations .mod-categories-child li a');

      this.$el.find('.donors input.mod-categories-search')
        .liveUpdate('.donors .mod-categories-child li a');

      this.$el.find('.countries input.mod-categories-search')
        .liveUpdate('.countries .mod-categories-child li a');
    }

  });

  return FiltersView;

});
