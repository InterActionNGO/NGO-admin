'use strict';

define([
  'jquery',
  'underscore',
  'backbone',
  'moment',
  'models/filter',
  'form',
  'select2'
], function($, _, Backbone, moment) {

  var ReportFormView = Backbone.View.extend({

    el: '#reportFormView',

    events: {
      'change #end_date_year': 'checkDate',
      'change #end_date_month': 'checkDate',
      'change #end_date_day': 'checkDate',
    },

    initialize: function() {
      var self = this;

      if (this.$el.length === 0) {
        return false;
      }

      this.$el.find('form').ajaxForm({
        beforeSubmit: function() {
          $(window).scrollTop(154);
          Backbone.Events.trigger('spinner:start');
          Backbone.Events.trigger('results:empty');
        },
        success: function(data) {
          self.onSuccess(data);
          Backbone.Events.trigger('spinner:stop');
        },
        error: function(err) {
          throw err.statusText;
        }
      });

      this.$el.find('select').select2({
        width: 'element'
      });

      this.$activeProjects = $('#activeProjects');
    },

    onSuccess: function(data) {
      this.model.clear({
        silent: true
      });

      this.model.set(_.extend({}, data.results, {
        charts: data.bar_chart
      }, {
        filters: data.filters
      }));
    },

    checkDate: function() {
      var currentEndDate = moment({
        year: $('#end_date_year').val(),
        month: $('#end_date_month').val() - 1,
        day: $('#end_date_day').val()
      });

      var isBefore = currentEndDate.isBefore(moment(), 'day');

      if (isBefore) {
        this.$activeProjects.addClass('is-hidden');
      } else {
        this.$activeProjects.removeClass('is-hidden');
      }
    }

  });

  return ReportFormView;

});
