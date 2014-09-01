'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'handlebars',
  'views/class/chart',
  'views/class/profile',
  'models/report',
  'text!templates/snapshot.handlebars'
], function(_, underscoreString, Backbone, Handlebars, SnapshotChart, ProfileView, ReportModel, tpl) {

  var OrganizationsSnapshotView = Backbone.View.extend({

    options: {
      limit: 10
    },

    el: '#organizationsSnapshotView',

    template: Handlebars.compile(tpl),

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showSnapshot, this);
    },

    render: function() {
      this.$el.html(this.template({
        snapshot: this.data,
        profile: this.profile
      }));
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    showSnapshot: function() {
      var organizations = ReportModel.instance.get('organizations');
      var len = organizations.length;

      this.data = this.profile = null;

      if (len > 1) {

        var organizationsByProjects = _.first(organizations, this.options.limit);
        var organizationsByCountries = _.first(_.sortBy(organizations, function(organization) {
          return -organization.countriesCount;
        }), this.options.limit);
        var organizationsByBudget = _.first(_.sortBy(organizations, function(organization) {
          return -organization.budget;
        }), this.options.limit);

        // var subtitle = 'A total of %(organizations)s found organizations, implementing %(projects)s projects by %(donors)s donors in %(countries)s countries across %(sectors)s sectors.'
        var subtitle = 'Out of %(organizations)s organizations.';

        this.data = {
          title: 'Top 10 Organizations',
          description: _.str.sprintf(subtitle, {
            organizations: len
          }),
          charts: [{
            name: 'By number of projects',
            series: _.map(organizationsByProjects, function(organization) {
              return {
                name: organization.name,
                data: [[organization.name, organization.projectsCount]]
              };
            })
          }, {
            name: 'By number of countries',
            series: _.map(organizationsByCountries, function(organization) {
              return {
                name: organization.name,
                data: [[organization.name, organization.countriesCount]]
              };
            })
          }, {
            name: 'By budget (USD)',
            series: _.map(organizationsByBudget, function(organization) {
              return {
                name: organization.name || 'Nameless',
                data: [[organization.name, organization.budget]]
              };
            })
          }]
        };

        this.render();

        this.setOrganizationsChart();

      } else {

        this.setProfile(organizations[0].id);

      }

      this.$el.removeClass('is-hidden');
    },

    setOrganizationsChart: function() {
      var $chartElements = this.$el.find('.mod-report-stacked-chart');

      $chartElements.each(_.bind(function(index, element) {
        var options = {
          chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            width: 188,
            reflow: false
            // height: (this.data.charts[index].series.length > 3) ? 600 : 250
          },
          series: this.data.charts[index].series
        };

        new SnapshotChart()
          .setElement($(element))
          .setChart(options);
      }, this));
    },

    setProfile: function(id) {
      var profileView = new ProfileView();

      profileView.setElement(this.el);

      profileView.getProfile({
        slug: 'organization',
        id: id
      });
    }

  });

  return OrganizationsSnapshotView;

});
