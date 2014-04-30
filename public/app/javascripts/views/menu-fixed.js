'use strict';

define(function() {

  var MenuFixedView = Backbone.View.extend({

    el: '#menuFixedView',

    events: {
      'click li a': 'onClick'
    },

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }
      this.$page = $('html, body');
    },

    onClick: function(e) {
      var target = $(e.currentTarget).attr('href').split('#')[1];
      var y = $('#' + target).offset().top;

      this.$page.animate({
        scrollTop: y
      }, 500);

      e.preventDefault();
    }

  });

  return MenuFixedView;

});
