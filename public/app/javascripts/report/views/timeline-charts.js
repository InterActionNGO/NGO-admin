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
], function($, _, Backbone, highcharts, moment, momentRange, ReportModel, FilterModel) {

  var TimelineChartsView = Backbone.View.extend({

    el: '#timelineChartsView',

    options: {
      chart: {
        type: 'line',
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
        line: {
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
      Backbone.Events.on('filters:done', this.showCharts, this);
    },

    showCharts: function() {
      this.$el.removeClass('is-hidden');
      this.setCharts();
    },

    setCharts: function() {
      var dateRange = moment().range(
        moment(FilterModel.instance.get('startDate')),
        moment(FilterModel.instance.get('endDate'))
      );
      var projects = ReportModel.instance.get('projects');
      var projectsLength = projects.length;

      var activeProjectsData = [];
      var totalProjectsData = [];
      var activeOrganizationsData = [];

      dateRange.by('months', function(date) {
        var activeProjects = [];
        var organizationsActives = [];
        var totalProjects = 0;
        var d = date.valueOf() - (date.zone() * 60000);

        for (var i = 0; i < projectsLength; i++) {
          var sd = new Date(projects[i].startDate).getTime();
          var ed = new Date(projects[i].endDate).getTime();
          if (d > sd && d < ed) {
            activeProjects.push(projects[i].organizationId);
          }
          if (d > ed) {
            totalProjects = totalProjects + 1;
          }
        }

        organizationsActives = _.uniq(activeProjects);

        activeProjectsData.push([d, activeProjects.length]);
        totalProjectsData.push([d, totalProjects]);
        activeOrganizationsData.push([d, organizationsActives.length]);
      });

      this.$projectChart.highcharts(_.extend({}, this.options, {
        title: {
          text: 'Number of Active Projects Over Time'
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
      }));

      this.$organizationsChart.highcharts(_.extend({}, this.options, {
        title: {
          text: 'Number of Active Organizations Over Time'
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
      }));
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    }

  });

  return TimelineChartsView;

});
