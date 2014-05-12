'use strict';

define(['select2'], function() {

  var SearchView = Backbone.View.extend({

    el: '#searchSidebarView',

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      this.$el.find('select').select2({
        width: 'element'
      });
    }

  });

  return SearchView;

});
