'use strict';

define([
  'underscore',
  'underscoreString',
  'backbone',
  'handlebars',
  'models/report',
  'text!templates/snapshot.handlebars'
], function(_, underscoreString, Backbone, Handlebars, ReportModel, tpl) {

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
          donors: ReportModel.instance.get('donors').length,
          projects: ReportModel.instance.get('projects').length,
          organizations: ReportModel.instance.get('organizations').length,
          countries: ReportModel.instance.get('countries').length,
          sectors: ReportModel.instance.get('sectors').length
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
