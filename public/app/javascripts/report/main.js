'use strict';

require.config({

  baseUrl: '/app/javascripts/report',

  paths: {
    jquery: '../../vendor/jquery/dist/jquery',
    jqueryui: '../../lib/jquery-ui/js/jquery-ui-1.10.4.custom',
    underscore: '../../vendor/underscore/underscore',
    underscoreString: '../../vendor/underscore.string/lib/underscore.string',
    backbone: '../../vendor/backbone/backbone',
    select2: '../../vendor/select2/select2',
    handlebars: '../../vendor/handlebars/handlebars',
    highcharts: '../../vendor/highcharts-release/highcharts',
    spin: '../../vendor/spinjs/spin',
    moment: '../../vendor/moment/moment',
    momentRange: '../../vendor/moment-range/lib/moment-range.bare',
    text: '../../vendor/requirejs-text/text'
  },

  shim: {
    jquery: {
      exports: '$'
    },
    jqueryui: {
      deps: ['jquery'],
      exports: '$'
    },
    underscore: {
      exports: '_'
    },
    underscoreString: {
      deps: ['underscore'],
      exports: '_.str'
    },
    backbone: {
      deps: ['jquery', 'underscore'],
      exports: 'Backbone'
    },
    sprintf: {
      exports: 'sprintf'
    },
    select2: {
      deps: ['jquery'],
      exports: '$'
    },
    form: {
      deps: ['jquery'],
      exports: '$'
    },
    handlebars: {
      exports: 'Handlebars'
    },
    highcharts: {
      deps: ['jquery'],
      exports: 'highcharts'
    },
    momentRange: {
      deps: ['moment'],
      exports: 'momentRange'
    }
  }

});

require([
  'underscore',
  'underscoreString',
  'handlebars',
  'views/filters-form',
  'views/result',
  'views/spin'
], function(_, underscoreString, Handlebars, FiltersFormView, ResultView, SpinView) {

  // Extensions
  Number.prototype.toCommas = function() {
    return _.str.numberFormat(this, 0);
  };

  // Handlebars
  Handlebars.registerHelper('commas', function(context) {
    if (!context) {
      return '0';
    }
    if (typeof context !== 'number') {
      return context;
    }
    return context.toCommas();
  });

  Handlebars.registerHelper('starray', function(context) {
    return _.str.toSentence(context);
  });

  // Initialize
  new SpinView();
  new FiltersFormView();
  new ResultView();

});
