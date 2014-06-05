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

      var h = $('.mod-header').height() + $('.mod-hero').height();

      this.$page = $('html, body');

      $(window).on('scroll', function(e) {
        if (e.currentTarget.pageYOffset > h) {
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
