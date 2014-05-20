'use strict';

define(['backbone', 'jquery', 'form', 'select2'], function(Backbone) {

  var ReportFormView = Backbone.View.extend({

    el: '#reportFormView',

    initialize: function() {
      var self = this;

      if (this.$el.length === 0) {
        return false;
      }

      this.$el.find('form').ajaxForm({
        beforeSubmit: function() {
          Backbone.Events.trigger('spinner:start');
          Backbone.Events.trigger('results:empty');
        },
        success: function(data) {
          self.onSuccess(data);
          Backbone.Events.trigger('spinner:stop');
        },
        error: function(err) {
          throw err.statusText;
        }
      }).submit();

      this.$el.find('select').select2({
        width: 'element'
      });
    },

    onSuccess: function(data) {
      this.model.clear({
        silent: true
      });

      this.model.set(data.results);
    }

  });

  return ReportFormView;

});
