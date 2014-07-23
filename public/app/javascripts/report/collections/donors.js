'use strict';

define([
  'underscore',
  'backbone'
], function(_, Backbone) {

  var DonorsCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
    },

    parse: function(data) {
      return _.map(data, function(donor) {
        return {
          name: donor.name,
          projectsCount: Number(donor.projects_count),
          countriesCount: Number(donor.countries_count),
          sectorsCount: Number(donor.sectors_count),
          organizationsCount: Number(donor.organizations_count)
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
          model: 'd'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return DonorsCollection;

});
