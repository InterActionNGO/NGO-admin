'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'handlebars',
  'views/class/chart',
  'models/report',
  'text!templates/snapshot.handlebars'
], function(_, underscoreString, Backbone, Handlebars, SnapshotChart, ReportModel, tpl) {

  var DonorsSnapshotView = Backbone.View.extend({

    options: {
      limit: 10
    },

    el: '#donorsSnapshotView',

    template: Handlebars.compile(tpl),

    initialize: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.showSnapshot, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    showSnapshot: function() {
      var donorsByProjects = _.first(ReportModel.instance.get('donors'), this.options.limit);
      var donorsByOrganizations = _.first(_.sortBy(ReportModel.instance.get('donors'), function(donor) {
        return -donor.organizationsCount;
      }), this.options.limit);
      var donorsByCountries = _.first(_.sortBy(ReportModel.instance.get('donors'), function(donor) {
        return -donor.countriesCount;
      }), this.options.limit);

      // var subtitle = 'A total of %(donors)s found donors, supporting %(projects)s projects by %(organizations)s organizations in %(countries)s countries across %(sectors)s sectors.';

      var subtitle = 'Out of %(donors)s donors.';

      this.data = {
        title: 'Top 10 Donors',
        description: _.str.sprintf(subtitle, {
          donors: ReportModel.instance.get('donors').length
        }),
        charts: [{
          name: 'By number of projects',
          series: _.map(donorsByProjects, function(donor) {
            return {
              name: donor.name || 'Nameless',
              data: [[donor.name, donor.projectsCount]]
            };
          })
        }, {
          name: 'By number of organizations',
          series: _.map(donorsByOrganizations, function(donor) {
            return {
              name: donor.name || 'Nameless',
              data: [[donor.name, donor.organizationsCount]]
            };
          })
        }, {
          name: 'By number of countries',
          series: _.map(donorsByCountries, function(donor) {
            return {
              name: donor.name || 'Nameless',
              data: [[donor.name, donor.countriesCount]]
            };
          })
        }]
      };

      this.render();

      this.setDonorsChart();

      this.$el.removeClass('is-hidden');
    },

    setDonorsChart: function() {
      var $chartElements = this.$el.find('.mod-report-stacked-chart');

      $chartElements.each(_.bind(function(index, element) {
        var options = {
          chart: {
            type: 'column',
            spacingLeft: 0,
            spacingRight: 0,
            width: 206
            // height: (this.data.charts[index].series.length > 3) ? 600 : 250
          },
          series: this.data.charts[index].series
        };

        new SnapshotChart()
          .setElement($(element))
          .setChart(options);
      }, this));
    }

  });

  return DonorsSnapshotView;

});
