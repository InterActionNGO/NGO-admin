'use strict';

define([
  'underscore',
  'backbone',
  'moment'
], function(_, Backbone, moment) {

  var NOW = moment();

  var ProjectsCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
    },

    parse: function(data) {
      return _.map(data, function(project) {
        return {
          name: project.name,
          budget: Number(project.budget),
          organizationId: Number(project.primary_organization),
          donorsCount: Number(project.donors_count),
          sectorsCount: Number(project.sectors_count),
          countriesCount: Number(project.countries_count),
          startDate: project.start_date,
          endDate: project.end_date,
          active: !!(moment(project.end_date).isAfter(NOW))
        };
      });
    },

    getByURLParams: function(URLParams, callback) {

      this.URLParams = URLParams;

      function onSuccess(collection) {
        if (callback && typeof callback) {
          callback(undefined, collection);
        }
      }

      function onError(collection, err) {
        if (callback && typeof callback) {
          callback(err);
        }
      }

      this.fetch({
        dataType: 'json',
        data: {
          model: 'p'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return ProjectsCollection;

});
