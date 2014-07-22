'use strict';

define([
  'views/class/lists'
], function(ListsView) {

  var SectorssListView = ListsView.extend({

    el: '#sectorsListView',

    options: {
      slug: 'sectors',
      limit: 30
    }

  });

  return SectorssListView;

});
