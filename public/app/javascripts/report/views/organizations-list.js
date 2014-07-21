'use strict';

define([
  'views/class/lists'
], function(ListsView) {

  var OrganizationsListView = ListsView.extend({

    el: '#organizationsListView',

    options: {
      slug: 'organizations',
      limit: 30
    }

  });

  return OrganizationsListView;

});
