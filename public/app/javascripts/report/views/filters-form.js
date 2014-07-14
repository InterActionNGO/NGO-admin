'use strict';

define([
  'jquery',
  'select2',
  'underscore',
  'backbone',
  'moment',
  'models/report',
  'models/filter'
], function($, select2, _, Backbone, moment, reportModel, filterModel) {

  var ReportFormView = Backbone.View.extend({

    el: '#reportFormView',

    events: {
      'submit form': 'onSubmit',
      'change #end_date_year': 'checkDate',
      'change #end_date_month': 'checkDate',
      'change #end_date_day': 'checkDate',
    },

    initialize: function() {
      this.$el.find('select').select2({
        width: 'element'
      });

      this.$window = $(window);
      this.$activeProjects = $('#activeProjects');
    },

    onSubmit: function(e) {
      var URLParams;

      Backbone.Events.trigger('spinner:start filters:fetch');
      this.$window.scrollTop(154);

      URLParams = $(e.currentTarget).serialize();

      filterModel.setByURLParams(URLParams);

      reportModel.getByURLParams(URLParams, function(err) {
        if (err) {
          throw err;
        }

        Backbone.Events.trigger('spinner:stop filters:done');
      });

      return false;
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
