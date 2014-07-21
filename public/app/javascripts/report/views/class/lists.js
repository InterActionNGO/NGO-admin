'use strict';

define([
  'underscore',
  'backbone',
  'handlebars',
  'models/report',
  'text!templates/lists.handlebars'
], function(_, Backbone, Handlebars, ReportModel, tpl) {

  var ListView = Backbone.View.extend({

    template: Handlebars.compile(tpl),

    initialize: function() {
      this.$page = $('html, body');
      Backbone.Events.on('list:show', this.showList, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    show: function() {
      console.log(ReportModel.instance.get(this.options.slug));
      this.data = {};
      this.data[this.options.slug] = _.first(ReportModel.instance.get(this.options.slug), this.options.limit);
      this.render();
      this.$el.removeClass('is-hidden');
      this.$page.animate({
        scrollTop: this.$el.offset().top - 30 + 'px'
      }, 300);
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    showList: function(list) {
      this.hide();
      if (list === this.options.slug) {
        this.show();
      }
    }

  });

  return ListView;

});
