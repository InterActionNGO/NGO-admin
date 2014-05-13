'use strict';

define(['backbone'], function(Backbone) {

  var LayerOverlayView = Backbone.View.extend({

    el: '.layer-overlay',

    events: {
      'click': 'hide',
      'click .mod-overlay-close': 'hide',
      'click .mod-overlay-content': 'show'
    },

    show: function() {
      this.$el.stop().fadeIn();
      return false;
    },

    hide: function(e) {
      this.$el.fadeOut();
      if (e.preventDefault) {
        e.preventDefault();
        e.stopPropagation();
      }
      return false;
    }

  });

  return LayerOverlayView;

});
