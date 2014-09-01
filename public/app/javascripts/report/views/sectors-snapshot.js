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

  var SectorsSnapshotView = Backbone.View.extend({

    options: {
      limit: 10
    },

    el: '#sectorsSnapshotView',

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
      var sectors = ReportModel.instance.get('sectors');
      var len = sectors.length;

      this.data = this.profile = null;

      if (len > 1) {

        var sectorsByProjects = _.first(sectors, this.options.limit);
        var sectorsByOrganizations = _.first(_.sortBy(sectors, function(sector) {
          return -sector.organizationsCount;
        }), this.options.limit);
        var sectorsByDonors = _.first(_.sortBy(sectors, function(sector) {
          return -sector.donorsCount;
        }), this.options.limit);

        // var subtitle = 'A total of %(sectors)s found sectors, supporting %(projects)s projects by %(donors)s donors and %(organizations)s organizations in %(countries)s countries.';
        var subtitle = 'Out of %(sectors)s sectors.';

        this.data = {
          title: 'Top 10 Sectors',
          description: _.str.sprintf(subtitle, {
            sectors: len
          }),
          charts: [{
            name: 'By number of projects',
            series: _.map(sectorsByProjects, function(sector) {
              return {
                name: sector.name,
                data: [[sector.name, sector.projectsCount]]
              };
            })
          }, {
            name: 'By number of organizations',
            series: _.map(sectorsByOrganizations, function(sector) {
              return {
                name: sector.name,
                data: [[sector.name, sector.organizationsCount]]
              };
            })
          }, {
            name: 'By number of donors',
            series: _.map(sectorsByDonors, function(sector) {
              return {
                name: sector.name,
                data: [[sector.name, sector.donorsCount]]
              };
            })
          }]
        };

        this.render();

        this.setSectorsChart();

      } else {

        this.profile = {};
        this.render();

      }

      this.$el.removeClass('is-hidden');
    },

    setSectorsChart: function() {
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
    }

  });

  return SectorsSnapshotView;

});
