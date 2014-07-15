'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'handlebars',
  'models/report',
  'views/snapshot/chart',
  'text!templates/snapshot.handlebars'
], function(_, underscoreString, Backbone, Handlebars, reportModel, ChartView, tpl) {

  var DonorsSnapshotView = Backbone.View.extend({

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
      this.data = {
        title: 'Donors snapshot',
        description: _.str.sprintf('A total of %(donors)s found donors, supporting %(projects)s projects by %(organizations)s organizations in %(countries)s countries across %(sectors)s sectors.', {
          donors: reportModel.get('donors').length,
          projects: reportModel.get('projects').length,
          organizations: reportModel.get('organizations').length,
          countries: reportModel.get('countries').length,
          sectors: reportModel.get('sectors').length
        }),
        charts: [{
          name: 'By number of projects',
          data: _.range(1, 10)
        }, {
          name: 'By number of organizations',
          data: _.range(1, 10)
        }, {
          name: 'By number of countries',
          data: _.range(1, 10)
        }]
      };

      this.render();

      this.$el.removeClass('is-hidden');
    },

    setDonorsChart: function() {
    }

  });

  return DonorsSnapshotView;

});
