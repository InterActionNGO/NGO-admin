'use strict';

define([
  'backbone',
  'handlebars',
  'text!../../../templates/totals.handlebars'
], function(Backbone, Handlebars, tpl) {

  var TotalsView = Backbone.View.extend({

    el: '#totalsView',

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.model.on('change:totals', this.render, this);
    },

    render: function() {
      this.$el.html(this.template({
        totals: this.model.toJSON().totals
      }));
    }

  });

  return TotalsView;

});
