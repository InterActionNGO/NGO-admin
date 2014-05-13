'use strict';

define(['select2'], function() {

  var SearchView = Backbone.View.extend({

    el: '#searchSidebarView',

    events: {
      'change select': 'onChange',
      'change input': 'onChange'
    },

    initialize: function() {
      if (this.$el.length === 0) {
        return false;
      }

      this.$el.find('select').select2({
        width: 'element'
      });
    },

    onChange: function() {
      this.$el.find('form').submit();
    }

  });

  return SearchView;

});
