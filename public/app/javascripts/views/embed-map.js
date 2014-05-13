'use strict';

define(function() {

  var EmbedMapView = Backbone.View.extend({

    el: '#embedMapView',

    events: {
      'click .mod-overlay-close': 'hide'
    },

    initialize: function() {
      var self = this;

      Backbone.Events.on('embed:show', this.show, this);

      this.$el.find('.mod-overlay-content')
        .on('mouseout', function() {
          self.$el.on('click', function(e) {
            self.hide(e);
          });
        }).on('mouseover', function() {
          self.$el.off('click');
        });
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
