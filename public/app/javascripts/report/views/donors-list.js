'use strict';

define([
  'views/class/lists'
], function(ListsView) {

  var DonorsListView = ListsView.extend({

    el: '#donorsListView',

    options: {
      slug: 'donors',
      limit: 30
    }

  });

  return DonorsListView;

});
