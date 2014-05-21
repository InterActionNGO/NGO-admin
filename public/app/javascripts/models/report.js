'use strict';

define([
  'backbone',
  'moment'
], function(Backbone, moment) {

  var ReportModel = Backbone.Model.extend({

    processData: function() {

      var active_years, disable_years, self = this;

      this.attributes.projects = _.map(this.attributes.projects, function(project) {
        project.project.year = Number(moment(project.project.start_date).format('YYYY'));
        project.project.active = (project.project.active === 't');
        return project.project;
      });

      active_years = _.sortBy(_.uniq(_.map(_.where(this.attributes.projects, {active: true}), function(project) {
        return project.year;
      })), function(year) {
        return year;
      });

      disable_years = _.sortBy(_.uniq(_.map(_.where(this.attributes.projects, {active: false}), function(project) {
        return project.year;
      })), function(year) {
        return year;
      });

      this.attributes.projects_active_series = _.map(active_years, function(year) {
        return [year, _.where(self.attributes.projects, {year: year, active: true}).length];
      });

      this.attributes.projects_disable_series = _.map(disable_years, function(year) {
        return [year, _.where(self.attributes.projects, {year: year, active: false}).length];
      });

      this.attributes.donors_by_projects = _.map(this.attributes.charts.donors.by_projects, function(donor) {
        return {
          name: donor.donor_name,
          data: [[donor.donor_name, Number(donor.n_projects)]]
        };
      });

      this.attributes.donors_by_organizations = _.map(this.attributes.charts.donors.by_organizations, function(donor) {
        return {
          name: donor.donor_name,
          data: [[donor.donor_name, Number(donor.n_organizations)]]
        };
      });

      this.attributes.donors_by_countries = _.map(this.attributes.charts.donors.by_countries, function(donor) {
        return {
          name: donor.donor_name,
          data: [[donor.donor_name, Number(donor.n_countries)]]
        };
      });

      return this;

    }

  });

  return ReportModel;

});
