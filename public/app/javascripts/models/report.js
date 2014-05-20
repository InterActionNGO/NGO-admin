'use strict';

define([
  'backbone',
  'moment'
], function(Backbone, moment) {

  var ReportModel = Backbone.Model.extend({

    processData: function() {

      // this.attributes.projects = _.map(this.attributes.projects, function(project) {
      //   project.project.year = moment(project.project.start_date).format('YYYY');
      //   project.project.active = (moment().year() < moment(project.project.start_date).year());
      //   return project.project;
      // });

      this.attributes.projects_active_series = _.where(this.attributes.projects, {active: true});

      return this;

    }

  });

  return ReportModel;

});
