'use strict';

define([
  'backbone',
  'moment'
], function(Backbone, moment) {

  var ReportModel = Backbone.Model.extend({

    processData: function() {

      var active_years, disable_years, organizations, years, self = this;

      function getLocations(locations_data) {
        var locations = _.map(locations_data, function(location_data) {
          var location = location_data.country.split('|');
          return {
            id: Number(location[0]),
            name: location[1],
            lat: Number(location[3]),
            lng: Number(location[2]),
            projects: Number(location_data.n_projects)
          };
        });
        return locations;
      }

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

      years = _.range(Number(moment(this.attributes.filters.start_date).format('YYYY')), Number(moment(this.attributes.filters.end_date).format('YYYY')) + 1);

      this.attributes.projects_active_series = _.map(years, function(year) {
        return [year, _.where(self.attributes.projects, {year: year, active: true}).length];
      });

      this.attributes.projects_disable_series = _.map(years, function(year) {
        return [year, _.where(self.attributes.projects, {year: year, active: false}).length];
      });

      organizations = _.uniq(_.map(this.attributes.projects, function(project) {
        return {
          year: project.year,
          id: project.primary_organization_id
        };
      }), function(organization) {
        return organization.id;
      });

      this.attributes.organizations_series = _.map(years, function(year) {
        return [year, _.where(organizations, {year: year}).length];
      });

      // Donors
      this.attributes.donors_by_projects = _.map(this.attributes.charts.donors.bar_chart.by_n_projects, function(donor) {
        return {
          name: donor.donor_name,
          data: [[donor.donor_name, Number(donor.n_projects)]],
          locations: getLocations(self.attributes.charts.donors.maps.by_n_projects)
        };
      });

      this.attributes.donors_by_organizations = _.map(this.attributes.charts.donors.bar_chart.by_n_organizations, function(donor) {
        return {
          name: donor.donor_name,
          data: [[donor.donor_name, Number(donor.n_organizations)]],
          locations: getLocations(self.attributes.charts.donors.maps.by_n_organizations)
        };
      });

      this.attributes.donors_by_countries = _.map(this.attributes.charts.donors.bar_chart.by_n_countries, function(donor) {
        return {
          name: donor.donor_name,
          data: [[donor.donor_name, Number(donor.n_countries)]],
          locations: getLocations(self.attributes.charts.donors.maps.by_n_countries)
        };
      });

      // Organizations
      this.attributes.organizations_by_projects = _.map(this.attributes.charts.organizations.bar_chart.by_n_projects, function(organization) {
        return {
          name: organization.organization_name,
          data: [[organization.organization_name, Number(organization.n_projects)]],
          locations: getLocations(self.attributes.charts.organizations.maps.by_n_projects)
        };
      });

      this.attributes.organizations_by_countries = _.map(this.attributes.charts.organizations.bar_chart.by_n_countries, function(organization) {
        return {
          name: organization.organization_name,
          data: [[organization.organization_name, Number(organization.n_countries)]],
          locations: getLocations(self.attributes.charts.organizations.maps.by_n_countries)
        };
      });

      this.attributes.organizations_by_bugdet = _.map(this.attributes.charts.organizations.bar_chart.by_total_budget, function(organization) {
        return {
          name: organization.organization_name,
          data: [[organization.organization_name, Number(organization.total_budget)]],
          locations: getLocations(self.attributes.charts.organizations.maps.by_total_budget)
        };
      });

      // Countries
      this.attributes.countries_by_donors = _.map(this.attributes.charts.countries.bar_chart.by_n_donors, function(country) {
        return {
          name: country.country_name,
          data: [[country.country_name, Number(country.n_donors)]],
          locations: getLocations(self.attributes.charts.countries.maps.by_n_donors)
        };
      });

      this.attributes.countries_by_organizations = _.map(this.attributes.charts.countries.bar_chart.by_n_organizations, function(country) {
        return {
          name: country.country_name,
          data: [[country.country_name, Number(country.n_organizations)]],
          locations: getLocations(self.attributes.charts.countries.maps.by_n_organizations)
        };
      });

      this.attributes.countries_by_projects = _.map(this.attributes.charts.countries.bar_chart.by_n_projects, function(country) {
        return {
          name: country.country_name,
          data: [[country.country_name, Number(country.n_projects)]],
          locations: getLocations(self.attributes.charts.countries.maps.by_n_projects)
        };
      });

      // Sectors
      this.attributes.sectors_by_donors = _.map(this.attributes.charts.sectors.bar_chart.by_n_donors, function(sector) {
        return {
          name: sector.sector_name,
          data: [[sector.sector_name, Number(sector.n_donors)]],
          locations: getLocations(self.attributes.charts.sectors.maps.by_n_donors)
        };
      });

      this.attributes.sectors_by_organizations = _.map(this.attributes.charts.sectors.bar_chart.by_n_organizations, function(sector) {
        return {
          name: sector.sector_name,
          data: [[sector.sector_name, Number(sector.n_organizations)]],
          locations: getLocations(self.attributes.charts.sectors.maps.by_n_organizations)
        };
      });

      this.attributes.sectors_by_projects = _.map(this.attributes.charts.sectors.bar_chart.by_n_projects, function(sector) {
        return {
          name: sector.sector_name,
          data: [[sector.sector_name, Number(sector.n_projects)]],
          locations: getLocations(self.attributes.charts.sectors.maps.by_n_projects)
        };
      });

      return this;
    }

  });

  return ReportModel;

});
