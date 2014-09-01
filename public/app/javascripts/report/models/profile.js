'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone'
], function(_, underscoreString, Backbone) {

  var ProfileModel = Backbone.Model.extend({

    url: function() {
      return _.str.sprintf('/profile/%s/%s', this.current.slug, this.current.id);
    },

    parse: function(data) {

      data.projects = _.map(data.projects, function(project) {
        var result = project.project;
        result.budget = Number(project.budget) || 0;
        return result;
      });

      data.sectors = _.sortBy(_.map(data.sectors, function(sector) {
        return {
          name: sector.sector.name,
          data: [[sector.sector.name, Number(sector.sector.count)]]
        };
      }), function(sector) {
        return -sector.data[0][1];
      });

      data.countries = _.sortBy(_.map(data.countries, function(country) {
        return {
          name: country.country.name,
          data: [[country.country.name, Number(country.country.count)]]
        };
      }), function(country) {
        return -country.data[0][1];
      });

      data.donors = _.sortBy(_.map(data.donors, function(donor) {
        return {
          name: donor.donor.name,
          data: [[donor.donor.name, Number(donor.donor.count)]]
        };
      }), function(donor) {
        return -donor.data[0][1];
      });

      data.budgets = {
        min: _.min(data.projects, function(project) {
          return project.budget;
        }, 0).budget,
        max: _.max(data.projects, function(project) {
          return project.budget;
        }, 0).budget
      };

      if (_.compact(data.budgets).length === 0) {
        data.budgets = null;
      }

      return data;
    },

    getByParams: function(obj, callback) {
      this.current = obj;

      this.fetch({
        success: callback,
        error: function(err) {
          throw err;
        }
      });
    }

  });

  return ProfileModel;

});
