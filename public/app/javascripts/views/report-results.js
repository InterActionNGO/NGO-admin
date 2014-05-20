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
      charts: {
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
      var options = _.extend({}, this.options.charts, {
        title: {
          text: null
        },
        yAxis: {
          title: {
            text: 'Projects'
          }
        },
        series: [{
          name: 'Active projects',
          data: this.data.projects_active_series
        }, {
          name: 'Inactive projects',
          data: this.data.projects_disable_series
        }]
      });

      $('#projectChart').highcharts(options);
    },

    donorsCharts: function() {
      var options = _.extend(this.options.charts, {
        chart: {
          type: 'column'
        },
        series: [{
          data: this.data.donors_by_projects
        }]
      });

      $('#donorsByProjectsChart').highcharts(options);
    }

  });

  return TotalsView;

});
