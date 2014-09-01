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

      data.min = _.min(data.projects, function(project) {
        return project.budget;
      }, 0).budget;

      data.max = _.max(data.projects, function(project) {
        return project.budget;
      }, 0).budget;

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
