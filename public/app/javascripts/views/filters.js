'use strict';

define(['liveupdate'], function() {

  var FiltersView = Backbone.View.extend({

    el: '#filtersView',

    initialize: function() {
      this.$el.find('.mod-categories-child').each(function(index, el) {
        $(el).find('input').liveUpdate('.mod-categories-child li a');
      });
    }

  });

  return FiltersView;

});
