'use strict';

define([
  'underscore',
  'backbone',
  'handlebars',
  'highcharts',
  'text!templates/report.handlebars'
], function(_, Backbone, Handlebars, highcharts, tpl) {

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
          allowDecimals: false,
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
          spacingRight: 0,
          height: 600
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
          useHTML: true,
          width: 200,
          itemWidth: 200,
          itemDistance: 0,
          itemMarginBottom: 10,
          itemStyle: {
            width: 175
          },
          labelFormatter: function() {
            var value = (Number(this.yData[0]) > 999) ? Number(this.yData[0]).toCommas() : this.yData[0];
            return this.name + ' (' + value + ')';
          }
        },
        yAxis: {
          allowDecimals: false,
          title: {
            text: null
          },
          lineWidth: 1,
          lineColor: '#989898',
          gridLineWidth: 0,
          minTickInterval: 1
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
      },
      map: {
        center: [0, 0],
        zoom: 11,
        maxZoom: 7,
        dragging: false,
        boxZoom: false,
        scrollWheelZoom: false,
        doubleClickZoom: false,
        touchZoom: false,
        zoomControl: false,
        attributionControl: false,
        keyboard: false
      }
    },

    events: {
      'click #printReport': 'printReport',
      'click #saveReport': 'saveReport'
    },

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.map = {};
      this.layer = {};
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
      var projectOptions = _.extend({}, this.options.areaChart, {
        title: {
          text: 'NGO Aid Map Project Number Over Time'
        },
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

      var organizationOption = _.extend({}, this.options.areaChart, {
        title: {
          text: 'Active Organizations Over Time'
        },
        series: [{
          name: 'Organizations',
          data: this.data.organizations_series,
          color: '#006C8D'
        }]
      });

      $('#projectChart').highcharts(projectOptions);
      $('#organizationChart').highcharts(organizationOption);
    },

    donorsCharts: function() {
      this.setHighchart('donorsByProjectsChart', this.data.donors_by_projects);
      this.setHighchart('donorsByOrganizationsChart', this.data.donors_by_organizations);
      this.setHighchart('donorsByCountriesChart', this.data.donors_by_countries);

      this.setLocationsMap('reportDonorsMap', 'reportDonorsLocations', 'donors_by_projects');
    },

    organizationsCharts: function() {
      this.setHighchart('organizationsByProjectsChart', this.data.organizations_by_projects);
      this.setHighchart('organizationsByCountriesChart', this.data.organizations_by_countries);
      this.setHighchart('organizationsByBudgetChart', this.data.organizations_by_bugdet);

      this.setLocationsMap('reportOrganizationsMap', 'reportOrganizationsLocations', 'organizations_by_projects');
    },

    countriesCharts: function() {
      this.setHighchart('countriesByProjectsChart', this.data.countries_by_donors);
      this.setHighchart('countriesByOrganizationsChart', this.data.countries_by_organizations);
      this.setHighchart('countriesByDonorsChart', this.data.countries_by_projects);

      this.setLocationsMap('reportCountriesMap', 'reportCountriesLocations', 'countries_by_donors');
    },

    sectorsCharts: function() {
      this.setHighchart('sectorsByProjectsChart', this.data.sectors_by_projects);
      this.setHighchart('sectorsByOrganizationsChart', this.data.sectors_by_organizations);
      this.setHighchart('sectorsByDonorsChart', this.data.sectors_by_donors);

      this.setLocationsMap('reportSectorsMap', 'reportSectorsLocations', 'sectors_by_projects');
    },

    printReport: function() {
      window.print();
    },

    saveReport: function() {
      //
    },

    setLocationsMap: function(el, target, layer) {
      var self = this;

      this.map[target] = L.map(el, this.options.map);

      L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(this.map[target]);

      $('#' + target).find('.mod-report-locations-header a').on('click', function(e) {
        e.preventDefault();
        var $el = $(e.currentTarget);
        var $parent = $el.closest('.mod-report-locations-header');

        $parent.find('.current').text($el.text());

        self.setLayer(self.map[target], target, $el.data('layer'));
      });

      if (this.data[layer].length > 0) {
        this.setLayer(this.map[target], target, layer);
      } else {
        $('#' + target).remove();
      }

      return this.map[target];
    },

    setLayer: function(map, target, layerType) {
      if (this.layer[target]) {
        this.map[target].removeLayer(this.layer[target]);
      }

      var locations = this.getGeoJSON(this.data[layerType]);
      var bounds;

      var layer = L.geoJson(locations, {
        pointToLayer: function(feature, latlng) {
          var size = (feature.properties.projects > 20) ? 1.2 * feature.properties.projects : 20;
          var fsize = (feature.properties.projects > 20) ? 0.6 * feature.properties.projects : 12;

          size = (size > 50) ? 50 : size;
          fsize = (fsize > 19) ? 19 : fsize;

          var marker = L.marker(latlng, {
            riseOnHover: true,
            icon: L.divIcon({
              iconSize: [size, size],
              iconAnchor: [size/2, size/2],
              className: 'report-marker',
              html: '<span style="line-height: ' + size +'px; font-size: ' + fsize + 'px">'+ feature.properties.projects + '</span>'
            })
          });
          return marker;
        }
      });

      bounds = layer.getBounds();

      map.addLayer(layer);

      if (bounds.isValid()) {
        map.fitBounds(layer.getBounds());
      }

      this.layer[target] = layer;

      return layer;
    },

    setHighchart: function(target, data) {
      var len = data.length, el = $('#' + target);

      if (len > 0) {
        el.highcharts(_.extend({}, this.options.columnChart, {
          chart: _.extend({}, this.options.columnChart.chart, {
            height: (data.length > 3) ? 600 : 250
          }),
          series: data
        }));
      } else {
        el.closest('.mod-report-grid-3').remove();
      }
    },

    getGeoJSON: function(data) {
      var locations = _.flatten(_.map(data, function(d) {
        return d.locations;
      }));

      var geojson = {};

      geojson.type = 'FeatureCollection';

      geojson.features = _.map(locations, function(d) {
        return {
          type: 'Feature',
          geometry: {
            type: 'Point',
            coordinates: [d.lat, d.lng]
          },
          properties: d
        };
      });

      return geojson;
    }

  });

  return TotalsView;

});
