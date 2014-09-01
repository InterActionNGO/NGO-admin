'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'handlebars',
  'views/class/chart',
  'models/report',
  'models/profile',
  'text!templates/profile.handlebars',
  'text!templates/snapshot.handlebars'
], function(_, underscoreString, Backbone, Handlebars,
  SnapshotChart, ReportModel, ProfileModel, profileTpl, snapshotTpl) {

  var SnapshotView = Backbone.View.extend({

    defaults: {
      snapshot: {
        limit: 10
      },
      profile: {
        limit: 5
      },
      chart: {
        chart: {
          type: 'column',
          spacingLeft: 0,
          spacingRight: 0,
          width: 188,
          reflow: false
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
          width: 188,
          itemWidth: 188,
          itemDistance: 0,
          itemMarginBottom: 10,
          itemStyle: {
            width: 160,
            fontWeight: 'normal',
            fontFamily: 'Akzidenz',
            fontSize: '13px'
          },
          labelFormatter: function() {
            var value = (Number(this.yData[0]) > 999) ? Number(this.yData[0]).toCommas() : this.yData[0];
            return this.name + ' (' + value + ')';
          },
          adjustChartSize: true
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
      }
    },

    templateSnapshot: Handlebars.compile(snapshotTpl),

    templateProfile: Handlebars.compile(profileTpl),

    initialize: function() {
      this.options = _.defaults(this.options || {}, this.defaults);

      this.reportModel = ReportModel.instance,
      this.profileModel = new ProfileModel();

      this._setListeners();
    },

    _setListeners: function() {
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('filters:done', this., this);
    },

    renderSnapshot: function() {
      this.$el.html(this.templateSnapshot( this.data ));
    },

    renderProfile: function() {
      this.$el.html(this.templateProfile(this.data));
    },

    show: function() {
      this.$el.removeClass('is-hidden');
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    show: function() {
      var organizations = this.reportModel.get(this.options.snapshot.slug);
      var len = organizations.length;

      this.data = this.profile = null;

      if (len > 1) {

        var organizationsByProjects = _.first(organizations, this.options.snapshot.limit);
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
                name: organization.name,
                data: [[organization.name, organization.budget]]
              };
            })
          }]
        };

        this.renderSnapshot();

        this.setChart();

      } else {

        $.when(
          this.getData()
        ).then(_.bind(function() {
          this.renderProfile();
          this.setChart();
        }, this));

      }

      this.show();
    },

    showSnapshot: function() {

    },

    getData: function() {
      var deferred = $.Deferred;

      var data = this.reportModel.get(this.options.snapshot.slug);
      var len = data.length;

      if () {}

      this.profileModel.getByParams({
        slug: this.options.profile.slug,
        id: id
      }, _.bind(function() {

        this.data = this.profileModel.toJSON();

        this.data.charts = [{
          name: this.options.profile.titles[0],
          series: _.first(this.data.sectors, this.options.profile.limit)
        }, {
          name: this.options.profile.titles[1],
          series: _.first(this.data.countries, this.options.profile.limit)
        }, {
          name: this.options.profile.titles[2],
          series: _.first(this.data.donors, this.options.profile.limit)
        }];

        deferred.resolve();

      }, this));

      return deferred.promise();
    },

    setChart: function() {
      var $chartElements = this.$el.find('.mod-report-stacked-chart');

      $chartElements.each(_.bind(function(index, element) {
        this.options.chart.series = this.data.charts[index].series;
        $(element).highcharts(this.options.chart);
      }, this));
    }

  });

  return SnapshotView;

});
