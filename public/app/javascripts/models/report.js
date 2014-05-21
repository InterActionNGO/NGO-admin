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

      // Donors
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

      // Organizations
      this.attributes.organizations_by_projects = _.map(this.attributes.charts.organizations.by_projects, function(organization) {
        return {
          name: organization.organization_name,
          data: [[organization.organization_name, Number(organization.n_projects)]]
        };
      });

      this.attributes.organizations_by_countries = _.map(this.attributes.charts.organizations.by_countries, function(organization) {
        return {
          name: organization.organization_name,
          data: [[organization.organization_name, Number(organization.n_countries)]]
        };
      });

      this.attributes.organizations_by_bugdet = _.map(this.attributes.charts.organizations.by_budget, function(organization) {
        return {
          name: organization.organization_name,
          data: [[organization.organization_name, Number(organization.total_budget)]]
        };
      });

      // Countries
      this.attributes.countries_by_donors = _.map(this.attributes.charts.countries.by_donors, function(country) {
        return {
          name: country.country_name,
          data: [[country.country_name, Number(country.n_donors)]]
        };
      });

      this.attributes.countries_by_organizations = _.map(this.attributes.charts.countries.by_organizations, function(country) {
        return {
          name: country.country_name,
          data: [[country.country_name, Number(country.n_organizations)]]
        };
      });

      this.attributes.countries_by_projects = _.map(this.attributes.charts.countries.by_projects, function(country) {
        return {
          name: country.country_name,
          data: [[country.country_name, Number(country.n_projects)]]
        };
      });

      // Sectors
      this.attributes.sectors_by_donors = _.map(this.attributes.charts.sectors.by_donors, function(sector) {
        return {
          name: sector.sector_name,
          data: [[sector.sector_name, Number(sector.n_donors)]]
        };
      });

      this.attributes.sectors_by_organizations = _.map(this.attributes.charts.sectors.by_organizations, function(sector) {
        return {
          name: sector.sector_name,
          data: [[sector.sector_name, Number(sector.n_organizations)]]
        };
      });

      this.attributes.sectors_by_projects = _.map(this.attributes.charts.sectors.by_projects, function(sector) {
        return {
          name: sector.sector_name,
          data: [[sector.sector_name, Number(sector.n_projects)]]
        };
      });

      return this;

    }

  });

  return ReportModel;

});
