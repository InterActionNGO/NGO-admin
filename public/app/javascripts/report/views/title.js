'use strict';

define([
  'backbone'
], function(Backbone) {

  var TitleView = Backbone.View.extend({

    el: '#titleView',

    events: {
      'keyup textarea': 'onKeyUp'
    },

    initialize: function() {
      this.$textarea = this.$el.find('textarea');
      this.autoResizeTextarea();
      Backbone.Events.on('filters:done', this.showFilters, this);
    },

    autoResizeTextarea: function() {
      this.$textarea.css('height', 0)
        .height(this.$textarea[0].scrollHeight);
    }

  });

  return TitleView;

});
