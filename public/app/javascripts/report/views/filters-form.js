'use strict';

define([
  'jquery',
  'select2',
  'underscore',
  'backbone',
  'moment',
  'models/report',
  'models/filter',
  'collections/projects',
  'collections/organizations',
  'collections/donors'
], function(
  $, select2, _, Backbone, moment, reportModel, filterModel,
  ProjectsCollection, OrganizationsCollection, DonorsCollection
) {

  var ReportFormView = Backbone.View.extend({

    el: '#reportFormView',

    events: {
      'submit form': 'onSubmit',
      'change #end_date_year': 'checkDate',
      'change #end_date_month': 'checkDate',
      'change #end_date_day': 'checkDate',
    },

    initialize: function() {
      this.projectsCollection = new ProjectsCollection();
      this.organizationsCollection = new OrganizationsCollection();
      this.donorCollection = new DonorsCollection();

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

      $.when(
        this.getProjects(),
        this.getOrganizations(),
        this.getDonors()
      ).then(_.bind(function() {

        reportModel.clear({
          silent: true
        });

        reportModel.set({
          donors: this.donorCollection.toJSON(),
          countries: [],
          sectors: [],
          projects: this.projectsCollection.toJSON(),
          organizations: this.organizationsCollection.toJSON()
        });

        Backbone.Events.trigger('spinner:stop filters:done');

      }, this));

      return false;
    },

    getProjects: function() {
      var deferred = $.Deferred();

      this.projectsCollection.getByURLParams('organization[]=Action Aid International USA', function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getOrganizations: function() {
      var deferred = $.Deferred();

      this.organizationsCollection.getByURLParams('organization[]=Action Aid International USA', function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getDonors: function() {
      var deferred = $.Deferred();

      this.donorCollection.getByURLParams('organization[]=Action Aid International USA', function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
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
