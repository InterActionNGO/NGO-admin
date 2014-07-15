'use strict';

define([
  'backbone'
], function(Backbone) {

  var OrganizationsCollection = Backbone.Collection.extend({

    url: function() {
      return '/list?' + this.URLParams;
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
          model: 'o'
        },
        success: onSuccess,
        error: onError
      });

    }

  });

  return OrganizationsCollection;

});
