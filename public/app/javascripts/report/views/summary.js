'use strict';

define([
  'backbone',
  'handlebars',
  'models/report',
  'text!templates/summary.handlebars'
], function(Backbone, Handlebars, reportModel, tpl) {

  var SummaryView = Backbone.View.extend({

    el: '#summaryView',

    template: Handlebars.compile(tpl),

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showSummary, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    showSummary: function() {
      this.data = reportModel.toJSON();

      this.render();

      this.$el.removeClass('is-hidden');
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return SummaryView;

});
