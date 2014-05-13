'use strict';

define(['backbone'], function(Backbone) {

  var MenuFixedView = Backbone.View.extend({

    el: '#menuFixedView',

    events: {
      'click li a': 'onClick'
    },

    initialize: function() {
      var self = this;

      if (this.$el.length === 0) {
        return false;
      }

      this.$page = $('html, body');

      $(window).on('scroll', function(e) {
        if (e.currentTarget.pageYOffset > 480) {
          self.$el.addClass('is-fixed');
        } else {
          self.$el.removeClass('is-fixed');
        }
      });
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
