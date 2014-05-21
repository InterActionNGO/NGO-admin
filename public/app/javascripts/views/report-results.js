'use strict';

define([
  'backbone',
  'handlebars',
  'highcharts',
  'text!../../templates/report.handlebars'
], function(Backbone, Handlebars, highcharts, tpl) {

  var TotalsView = Backbone.View.extend({

    el: '#totalsView',

    options: {
      areaChart: {
        chart: {
          type: 'area',
          spacingLeft: 0,
          spacingRight: 0
        },
        title: {
          text: null
        },
        xAxis: {
          lineWidth: 0,
          tickLength: 0
        },
        yAxis: {
          title: {
            text: null
          },
          gridLineWidth: 0
        },
        plotOptions: {
          area: {
            fillOpacity: 0.5,
            tooltip: {
              headerFormat: '',
              pointFormat: '<strong>{point.x}:</strong> {point.y}'
            }
          }
        },
        credits: {
          enabled: false
        }
      },
      columnChart: {
        chart: {
          type: 'column',
          spacingLeft: 0,
          spacingRight: 0
        },
        title: {
          text: null
        },
        colors: ['#CBCBCB', '#323232', '#006C8D', '#AACED9', '#878787', '#8E921B', '#CDCF9A', '#C45017', '#E5B198', '#D7A900'],
        plotOptions: {
          column: {
            pointPadding: 0.05,
            groupPadding: 0,
            tooltip: {
              headerFormat: '',
              pointFormat: '{point.y}'
            }
          }
        },
        legend: {
          width: 200,
          itemWidth: 200,
          itemDistance: 0,
          itemMarginBottom: 10,
          itemStyle: {
            width: 175
          }
        },
        yAxis: {
          title: {
            text: null
          },
          lineWidth: 1,
          lineColor: '#989898',
          gridLineWidth: 0
        },
        xAxis: {
          labels: {
            enabled: false
          },
          tickLength: 0,
          lineColor: '#989898'
        },
        credits: {
          enabled: false
        }
      }
    },

    template: Handlebars.compile(tpl),

    initialize: function() {
      Backbone.Events.on('results:empty', this.empty, this);
      this.model.on('change', this.render, this);
    },

    render: function() {
      this.data = this.model.processData().toJSON();
      this.$el.html(this.template(this.data));

      $('#modReportsTabs').tabs();

      this.calculeReportBudget();
      this.setProjectsChart();
      this.donorsCharts();
      this.organizationsCharts();
      this.countriesCharts();
      this.sectorsCharts();
    },

    empty: function() {
      this.$el.html('');
    },

    calculeReportBudget: function() {
      var $budgetChart = $('#reportBudgetChart');
      var min = $budgetChart.data('min');
      var max = $budgetChart.data('max');
      var average = $budgetChart.data('average');
      var total = Number(min) + Number(max) + Number(average);
      var w = $budgetChart.width() - 2;

      $budgetChart
        .append('<div class="mod-report-budget-chart-item min" style="width: ' + ((min * w) / total).toFixed(0) + 'px">')
        .append('<div class="mod-report-budget-chart-item average" style="width: ' + ((average * w) / total).toFixed(0) + 'px">')
        .append('<div class="mod-report-budget-chart-item max" style="width: ' + ((max * w) / total).toFixed(0) + 'px">');
    },

    setProjectsChart: function() {
      var options = _.extend(this.options.areaChart, {
        series: [{
          name: 'Inactive projects',
          data: this.data.projects_disable_series,
          color: '#CBCBCB'
        }, {
          name: 'Active projects',
          data: this.data.projects_active_series,
          color: '#006C8D'
        }]
      });

      $('#projectChart').highcharts(options);
    },

    donorsCharts: function() {
      $('#donorsByProjectsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.donors_by_projects
      }));

      $('#donorsByOrganizationsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.donors_by_organizations
      }));

      $('#donorsByCountriesChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.donors_by_countries
      }));
    },

    organizationsCharts: function() {
      $('#organizationsByProjectsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.organizations_by_projects
      }));

      $('#organizationsByCountriesChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.organizations_by_countries
      }));

      $('#organizationsByBudgetChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.organizations_by_bugdet
      }));
    },

    countriesCharts: function() {
      $('#countriesByProjectsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.countries_by_donors
      }));

      $('#countriesByOrganizationsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.countries_by_organizations
      }));

      $('#countriesByDonorsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.countries_by_projects
      }));
    },

    sectorsCharts: function() {
      $('#sectorsByProjectsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.sectors_by_projects
      }));

      $('#sectorsByOrganizationsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.sectors_by_organizations
      }));

      $('#sectorsByDonorsChart').highcharts(_.extend(this.options.columnChart, {
        series: this.data.sectors_by_donors
      }));
    }

  });

  return TotalsView;

});
