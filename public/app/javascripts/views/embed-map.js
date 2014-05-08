'use strict';

define(function() {

  var EmbedMapView = Backbone.View.extend({

    el: '#embedMapView',

    events: {
      'click .mod-overlay-close': 'hide'
    },

    initialize: function() {
      Backbone.Events.on('embed:show', this.show, this);
    },

    show: function() {
      this.$el.fadeIn();
    },

    hide: function(e) {
      this.$el.fadeOut();
      if (e.preventDefault) {
        e.preventDefault();
      }
    }

  });

  return EmbedMapView;

});
