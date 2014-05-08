'use strict';

define(function() {

  var DownloadsView = Backbone.View.extend({

    el: '#downloadsView',

    events: {
      'click #embedMapBtn': 'showOverlay'
    },

    showOverlay: function(e) {
      Backbone.Events.trigger('embed:show');
      e.preventDefault();
    }

  });

  return DownloadsView;

});
