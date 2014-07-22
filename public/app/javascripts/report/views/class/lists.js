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
      'click .report-lists-selector a': '_onClickSelector'
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
      var items = ReportModel.instance.get(this.options.slug);
      this.hide();
      if (list.name === this.options.slug) {
        this.data = {};
        this.data[this.options.slug] = _.first(_.sortBy(items, function(item) {
          return -item[list.category];
        }), this.options.limit);
        this.render();
        this.show();
      }
    },

    _onClickSelector: function(e) {
      this._showList({
        name: this.options.slug,
        category: $(e.currentTarget).data('category')
      });

      e.preventDefault();
    }

  });

  return ListView;

});
