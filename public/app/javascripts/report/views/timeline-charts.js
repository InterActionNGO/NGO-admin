'use strict';

define([
  'jqueryui',
  'underscore',
  'backbone',
  'highcharts',
  'moment',
  'momentRange',
  'models/report',
  'models/filter'
], function($, _, Backbone, highcharts, moment, momentRange, reportModel, filterModel) {

  var TimelineChartsView = Backbone.View.extend({

    el: '#timelineChartsView',

    options: {
      chart: {
        type: 'area',
        spacingLeft: 0,
        spacingRight: 0,
        zoomType: 'x'
      },
      xAxis: {
        lineWidth: 0,
        tickLength: 0,
        type: 'datetime'
      },
      tooltip: {
        headerFormat: '{point.x:%b %Y}<br>',
        pointFormat: '<strong>{point.y} projects</strong> '
      },
      plotOptions: {
        fillOpacity: 0.5,
        area: {
          marker: {
            enabled: false,
            symbol: 'circle',
            radius: 2,
            states: {
              hover: {
                enabled: true
              }
            }
          }
        }
      },
      yAxis: {
        allowDecimals: false,
        title: {
          text: null
        },
        gridLineWidth: 0
      },
      credits: {
        enabled: false
      }
    },

    initialize: function() {
      this.$projectChart = $('#projectsChart');
      this.$organizationsChart = $('#organizationsChart');
      $('#modReportsTabs').tabs();
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this.show, this);
    },

    show: function() {
      this.$el.removeClass('is-hidden');
      this.setCharts();
    },

    setCharts: function() {
      var startDate = moment(filterModel.get('startDate'));
      var endDate = moment(filterModel.get('endDate'));
      var dateRange = moment().range(startDate, endDate);
      var projects = reportModel.get('projects');
      var activeProjectsData = [];
      var totalProjectsData = [];
      var activeOrganizationsData = [];
      var projectsOptions = {};
      var organizationsOptions = {};

      dateRange.by('months', function(date) {
        var activeProjects = _.filter(projects, function(project) {
          return moment().range(
            moment(project.startDate, 'YYYY-MM-DD'),
            moment(project.endDate, 'YYYY-MM-DD')
          ).contains(date);
        });

        var totalProjects = _.filter(projects, function(project) {
          return moment(project.endDate, 'YYYY-MM-DD').isBefore(date);
        });

        var organizationsActives = _.uniq(activeProjects, function(project) {
          return project.organizationId;
        });

        activeProjectsData.push([date.valueOf(), activeProjects.length]);
        totalProjectsData.push([date.valueOf(), totalProjects.length]);
        activeOrganizationsData.push([date.valueOf(), organizationsActives.length]);
      });

      projectsOptions = _.extend({}, this.options, {
        title: {
          text: 'NGO Aid Map Project Number Over Time'
        },
        series: [{
          name: 'Total projects',
          data: totalProjectsData,
          color: '#CBCBCB'
        }, {
          name: 'Active projects',
          data: activeProjectsData,
          color: '#006C8D'
        }]
      });

      organizationsOptions = _.extend({}, this.options, {
        title: {
          text: 'Active Organizations Over Time'
        },
        tooltip: {
          headerFormat: '{point.x:%b %Y}<br>',
          pointFormat: '<strong>{point.y} organizations</strong> '
        },
        series: [{
          name: 'Organizations',
          data: activeOrganizationsData,
          color: '#006C8D'
        }]
      });

      this.$projectChart.highcharts(projectsOptions);
      this.$organizationsChart.highcharts(organizationsOptions);
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return TimelineChartsView;

});
