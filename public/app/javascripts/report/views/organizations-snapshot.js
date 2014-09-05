'use strict';

define([
  'backbone',
  'views/class/snapshot'
], function(Backbone, SnapshotView) {

  var OrganizationsSnapshotView = SnapshotView.extend({

    el: '#organizationsSnapshotView',

    options: {
      snapshot: {
        title: 'Top 10 Organizations',
        subtitle: 'Out of %s organizations.',
        slug: 'organizations',
        limit: 10,
        graphsBy: [{
          title: 'By number of projects',
          slug: 'projectsCount'
        }, {
          title: 'By number of countries',
          slug: 'countriesCount'
        }, {
          title: 'By Total Project Budget (USD)',
          slug: 'budget'
        }]
      },
      profile: {
        slug: 'organization',
        limit: 5,
        graphsBy: [{
          title: 'Projects by sectors',
          slug: 'sectors'
        }, {
          title: 'By number of countries',
          slug: 'countries'
        }, {
          title: 'By number of donors',
          slug: 'donors'
        }]
      }
    }

  });

  return OrganizationsSnapshotView;

});
