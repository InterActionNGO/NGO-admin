'use strict';

define(['backbone'], function(Backbone) {

  var TimelineView = Backbone.View.extend({

    el: '#timelineView',

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      var w = this.$el.find('.timeline').width();
      var d = new Date();
      var total_days = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate($('p.second_date').text()));
      var days_completed = this.daydiff(this.parseDate($('p.first_date').text()), this.parseDate((d.getMonth() + 1) + '/' + (d.getDate()) + '/' + (d.getFullYear())));

      console.log(total_days, days_completed);

      if (days_completed < total_days) {
        this.$el.find('.timeline-status').width((days_completed * w) / total_days);
      }
    },

    daydiff: function(first, second) {
      return (second - first) / (1000 * 60 * 60 * 24);
    },

    parseDate: function(str) {
      var mdy = str.split('/');
      return new Date(mdy[2], mdy[0]-1, mdy[1]);
    }

  });

  return TimelineView;

});
