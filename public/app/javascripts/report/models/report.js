'use strict';

define([
  'backbone',
], function(Backbone) {

  var ReportModel = Backbone.Model.extend({

    defaults: {
      donors: [],
      organizations: [],
      projects: [],
      countries: [],
      sectors: []
    }

  });

  return new ReportModel();

});
