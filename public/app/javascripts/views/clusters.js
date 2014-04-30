'use strict';

define(function() {

  var ClustersView = Backbone.View.extend({

    el: '#clustersView',

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      var $items = this.$el.find('a'),
      w = this.$el.width(),
      values = [],
      max = $($items[0]).data('value');

      for (var i = 0, len = $items.length; i < len; i++) {
        var item = $($items[i]);
        var value = item.attr('data-value');
        var itemWidth = (value / max) * (w - 22);

        if (itemWidth - 30 > 0) {
          item.find('.aller').css('width', itemWidth + 'px');
        } else {
          item.find('.aller').css('width', itemWidth + 10 + 'px');
        }
      }
    }

  });

  return ClustersView;

});
