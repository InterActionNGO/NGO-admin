'use strict';

define([
  'backbone',
  'views/class/snapshot'
], function(Backbone, SnapshotView) {

  var OrganizationsSnapshotView = SnapshotView.extend({

    el: '#organizationsSnapshotView',

    options: {
      snapshot: {
        slug: 'organizations',
        limit: 10,
        titles: [
          'By number of projects',
          'By number of countries',
          'By budget (USD)'
        ],
        subtitle: 'Out of %(organizations)s organizations.'
      },
      profile: {
        slug: 'organization',
        limit: 5,
        titles: [
          'Projects by sectors',
          'By number of countries',
          'By number of donors'
        ]
      }
    }

  });

  return OrganizationsSnapshotView;

});
