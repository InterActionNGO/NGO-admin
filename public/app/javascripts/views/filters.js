'use strict';

define(['backbone', 'liveupdate'], function(Backbone) {

  function is_touch_device() {
    return 'ontouchstart' in window || 'onmsgesturechange' in window;
  }

  var FiltersView = Backbone.View.extend({

    el: '#filtersView',

    initialize: function() {
      this.$el.find('.organizations input.mod-categories-search')
        .liveUpdate('.organizations .mod-categories-child li a');

      this.$el.find('.donors input.mod-categories-search')
        .liveUpdate('.donors .mod-categories-child li a');

      this.$el.find('.countries input.mod-categories-search')
        .liveUpdate('.countries .mod-categories-child li a');

      if (is_touch_device()) {
        this.$el.find('.father').on('touchstart', function(ev) {
          $(ev.currentTarget)
            .closest('li').toggleClass('is-touched')
            .find('.mod-go-up-menu').toggle();
        });
      }
    }

  });

  return FiltersView;

});
