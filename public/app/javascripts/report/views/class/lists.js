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
      'click .is-inline-btn': 'hide',
      'click .is-show-all-btn': '_toggleShowAll'
    },

    initialize: function() {
      this.isShowAllActive = false;
      this.$page = $('html, body');
      Backbone.Events.on('filters:fetch', this.hide, this);
      Backbone.Events.on('list:toggle', this._toggleList, this);
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
      Backbone.Events.trigger('list:hide', this.options);
    },

    _showList: function(list) {
      var items = ReportModel.instance.get(list.name);
      var result = [];
      var rLen = 0;
      var iLen = 0;

      this.currentList = list;

      if (list.name === this.options.slug) {
        this.data = {};
        result = _.sortBy(items, function(item) {
          if (typeof item[list.category] === 'string') {
            return item[list.category];
          }
          return -item[list.category];
        });

        if (this.options.limit) {
          result = _.first(result, this.options.limit);
        }

        iLen = items.length;
        rLen = result.length;

        this.data[this.options.slug] = result;
        this.data.title = (!this.options.limit || iLen < this.options.limit) ? null : rLen;
        this.data.isLong = iLen > result.length;
        this.data.isActive = this.isShowAllActive;
        this.render();
        _.delay(_.bind(this.show, this), 200);
      }
    },

    _toggleList: function(list) {
      if (list.name === this.options.slug) {
        if (this.$el.hasClass('is-hidden')) {
          this._showList(list);
        } else {
          this.hide();
        }
      }
    },

    _toggleShowAll: function() {
      if (this.isShowAllActive) {
        this.options.limit = 30;
        this.isShowAllActive = false;
      } else {
        this.isShowAllActive = true;
        this.options.limit = null;
      }
      this._showList(this.currentList);
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
