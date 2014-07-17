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
  'collections/donors',
  'collections/countries',
  'collections/sectors'
], function(
  $, select2, _, Backbone, moment, ReportModel, FilterModel,
  ProjectsCollection, OrganizationsCollection, DonorsCollection, CountriesCollection, SectorsCollection
) {

  var ReportFormView = Backbone.View.extend({

    el: '#reportFormView',

    events: {
      'submit form': 'fetchData',
      'change #end_date_year': 'checkDate',
      'change #end_date_month': 'checkDate',
      'change #end_date_day': 'checkDate',
    },

    initialize: function() {
      this.projectsCollection = new ProjectsCollection();
      this.organizationsCollection = new OrganizationsCollection();
      this.donorsCollection = new DonorsCollection();
      this.countriesCollection = new CountriesCollection();
      this.sectorsCollection = new SectorsCollection();

      this.$el.find('select').select2({
        width: 'element'
      });

      this.$window = $(window);
      this.$activeProjects = $('#activeProjects');

      if (window.location.search !== '') {
        this.fetchData();
      }
    },

    fetchData: function() {
      Backbone.Events.trigger('spinner:start filters:fetch');

      this.$window.scrollTop(154);

      this.URLParams = this.$el.find('form').serialize();

      FilterModel.instance.setByURLParams(this.URLParams);

      $.when(
        this.getDonors(),
        this.getProjects(),
        this.getOrganizations(),
        this.getCountries(),
        this.getSectors()
      ).then(_.bind(function() {

        var data = {
          donors: this.donorsCollection.toJSON(),
          projects: this.projectsCollection.toJSON(),
          organizations: this.organizationsCollection.toJSON(),
          countries: this.countriesCollection.toJSON(),
          sectors: this.sectorsCollection.toJSON()
        };

        ReportModel.instance.set(data);

        if (window.location.search === '') {
          window.history.pushState({}, '', window.location.pathname + '?' + this.URLParams);
        }

        Backbone.Events.trigger('spinner:stop filters:done');

      }, this));

      return false;
    },

    getProjects: function() {
      var deferred = $.Deferred();

      this.projectsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getOrganizations: function() {
      var deferred = $.Deferred();

      this.organizationsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getDonors: function() {
      var deferred = $.Deferred();

      this.donorsCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getCountries: function() {
      var deferred = $.Deferred();

      this.countriesCollection.getByURLParams(this.URLParams, function(err) {
        if (err) {
          throw err;
        }
        deferred.resolve();
      });

      return deferred.promise();
    },

    getSectors: function() {
      var deferred = $.Deferred();

      this.sectorsCollection.getByURLParams(this.URLParams, function(err) {
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
