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
        success: function(data) {
          self.onSuccess(data);
        },
        error: function(err) {
          throw err.statusText;
        }
      });

      this.$el.find('select').select2({
        width: 'element'
      });
    },

    onSuccess: function(data) {
      this.model.set(data, {
        reset: true
      });

      console.log(this.model.toJSON());
    }

  });

  return ReportFormView;

});
