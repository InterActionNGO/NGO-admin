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
            return this.name +' (' + (this.yData[0]) + ')';
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
      var self = this;

      $('#donorsByProjectsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.donors_by_projects
      }));

      $('#donorsByOrganizationsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.donors_by_organizations
      }));

      $('#donorsByCountriesChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.donors_by_countries
      }));

      self.donorsMap = self.setMap('reportDonorsMap');

      function setDonorsLocations(layer) {
        if (self.donorsLayer) {
          self.donorsMap.removeLayer(self.donorsLayer);
        }
        self.donorsLayer = self.setLayer(self.donorsMap, layer);
      }

      $('#reportDonorsLocations').find('.mod-report-locations-header a').on('click', function(e) {
        e.preventDefault();
        var $el = $(e.currentTarget);
        var $parent = $el.closest('.mod-report-locations-header');

        $parent.find('.current').text($el.text());

        setDonorsLocations($el.data('layer'));
      });

      setDonorsLocations('donors_by_projects');
    },

    organizationsCharts: function() {
      var self = this;

      $('#organizationsByProjectsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.organizations_by_projects
      }));

      $('#organizationsByCountriesChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.organizations_by_countries
      }));

      $('#organizationsByBudgetChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.organizations_by_bugdet
      }));

      self.organizationsMap = self.setMap('reportOrganizationsMap');

      function setOrganizationsLocations(layer) {
        if (self.organizationsLayer) {
          self.organizationsMap.removeLayer(self.organizationsLayer);
        }
        self.organizationsLayer = self.setLayer(self.organizationsMap, layer);
      }

      $('#reportOrganizationsLocations').find('.mod-report-locations-header a').on('click', function(e) {
        e.preventDefault();
        var $el = $(e.currentTarget);
        var $parent = $el.closest('.mod-report-locations-header');

        $parent.find('.current').text($el.text());

        setOrganizationsLocations($el.data('layer'));
      });

      setOrganizationsLocations('organizations_by_projects');
    },

    countriesCharts: function() {
      var self = this;

      $('#countriesByProjectsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.countries_by_donors
      }));

      $('#countriesByOrganizationsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.countries_by_organizations
      }));

      $('#countriesByDonorsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.countries_by_projects
      }));

      self.countriesMap = self.setMap('reportCountriesMap');

      function setCountriesLocations(layer) {
        if (self.countriesLayer) {
          self.countriesMap.removeLayer(self.countriesLayer);
        }

        self.countriesLayer = self.setLayer(self.countriesMap, layer);
      }

      $('#reportCountriesLocations').find('.mod-report-locations-header a').on('click', function(e) {
        e.preventDefault();
        var $el = $(e.currentTarget);
        var $parent = $el.closest('.mod-report-locations-header');

        $parent.find('.current').text($el.text());

        setCountriesLocations($el.data('layer'));
      });

      setCountriesLocations('countries_by_donors');
    },

    sectorsCharts: function() {
      var self = this;

      $('#sectorsByProjectsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.sectors_by_projects
      }));

      $('#sectorsByOrganizationsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.sectors_by_organizations
      }));

      $('#sectorsByDonorsChart').highcharts(_.extend({}, this.options.columnChart, {
        series: this.data.sectors_by_donors
      }));

      self.sectorsMap = self.setMap('reportSectorsMap');

      function setSectorsLocations(layer) {
        if (self.sectorsLayer) {
          self.sectorsMap.removeLayer(self.sectorsLayer);
        }
        self.sectorsLayer = self.setLayer(self.sectorsMap, layer);
      }

      $('#reportSectorsLocations').find('.mod-report-locations-header a').on('click', function(e) {
        e.preventDefault();
        var $el = $(e.currentTarget);
        var $parent = $el.closest('.mod-report-locations-header');

        $parent.find('.current').text($el.text());

        setSectorsLocations($el.data('layer'));
      });

      setSectorsLocations('sectors_by_projects');
    },

    printReport: function() {
      window.print();
    },

    saveReport: function() {
      //
    },

    setMap: function(el) {
      var map = L.map(el, this.options.map);

      L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);

      return map;
    },

    setLayer: function(map, layerType) {
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

      return layer;
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
