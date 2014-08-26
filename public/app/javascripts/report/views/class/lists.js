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

    events: {
      'click .mod-report-lists-selector a': '_onClickSelector',
      'click .is-inline-btn': 'hide'
    },

    initialize: function() {
      this.$page = $('html, body');
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('list:show', this._showList, this);
    },

    render: function() {
      this.$el.html(this.template(this.data));
    },

    show: function() {
      this.$el.removeClass('is-hidden');
      this.$page.animate({
        scrollTop: this.$el.offset().top - 30 + 'px'
      }, 300);
    },

    hide: function() {
      this.$el.addClass('is-hidden');
    },

    _showList: function(list) {
      var items = ReportModel.instance.get(list.name);
      this.hide();
      if (list.name === this.options.slug) {
        this.data = {};
        this.data[this.options.slug] = _.first(_.sortBy(items, function(item) {
          return -item[list.category];
        }), this.options.limit);
        this.render();
        _.delay(_.bind(this.show, this), 200);
      }
    },

    _onClickSelector: function(e) {
      var $current = $(e.currentTarget);
      var currentText = $current.text();

      this._showList({
        name: this.options.slug,
        category: $current.data('category')
      });

      this.$el.find('.current').text(currentText);

      e.preventDefault();
    }

  });

  return ListView;

});