'use strict';

require.config({

  baseUrl: '/app/javascripts/report',

  paths: {
    jquery: '../../vendor/jquery/dist/jquery',
    underscore: '../../vendor/underscore/underscore',
    underscoreString: '../../vendor/underscore.string/lib/underscore.string',
    backbone: '../../vendor/backbone/backbone',
    select2: '../../vendor/select2/select2',
    form: '../../vendor/jquery-form/jquery.form',
    handlebars: '../../vendor/handlebars/handlebars',
    highcharts: '../../vendor/highcharts-release/highcharts',
    spin: '../../vendor/spinjs/spin',
    moment: '../../vendor/moment/moment',
    text: '../../vendor/requirejs-text/text'
  },

  shim: {
    jquery: {
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
    }
  }

});

require([
  'handlebars',
  'underscoreString',
  'models/report',
  'views/filters-form',
  'views/result',
  'views/spin'
], function(Handlebars, _, ReportModel, FiltersFormView, ResultView, SpinView) {

  // Extensions
  Number.prototype.toCommas = function() {
    return _.str.numberFormat(this.toString(), 0);
  };

  // Handlebars
  Handlebars.registerHelper('commas', function(context) {
    if (typeof context !== 'number') {
      return context;
    }
    return context.toCommas();
  });

  Handlebars.registerHelper('starray', function(context) {
    return _.str.toSentence(context);
  });

  // Initialize
  var reportModel = new ReportModel();

  new SpinView();

  new FiltersFormView({
    model: reportModel
  });

  new ResultView({
    model: reportModel
  });

});
