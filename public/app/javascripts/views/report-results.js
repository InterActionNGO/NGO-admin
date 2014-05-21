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
          type: 'area'
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
            fillOpacity: 0.5
          }
        },
        credits: {
          enabled: false
        }
      },
      columnChart: {
        chart: {
          type: 'column'
        },
        title: {
          text: null
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
      console.log(this.data);
      this.$el.html(this.template(this.data));
      this.calculeReportBudget();
      this.setProjectsChart();
      this.donorsCharts();
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
    }

  });

  return TotalsView;

});
