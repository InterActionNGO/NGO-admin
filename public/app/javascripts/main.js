'use strict';

require.config({

  baseUrl: '/app/javascripts',

  paths: {
    jquery: '../vendor/jquery/dist/jquery',
    underscore: '../vendor/underscore/underscore',
    backbone: '../vendor/backbone/backbone',
    sprintf: '../vendor/sprintf/src/sprintf',
    quicksilver: '../lib/liveupdate/quicksilver',
    liveupdate: '../lib/liveupdate/jquery.liveupdate',
    jqueryui: '../lib/jquery-ui/js/jquery-ui-1.10.4.custom',
    select2: '../vendor/select2/select2',
    form: '../vendor/jquery-form/jquery.form',
    handlebars: '../vendor/handlebars/handlebars',
    highcharts: '../vendor/highcharts-release/highcharts',
    chachiSlider: '../vendor/chachi-slider/jquery.chachi-slider',
    spin: '../vendor/spinjs/spin',
    moment: '../vendor/moment/moment',
    text: '../vendor/requirejs-text/text'
  },

  shim: {
    jquery: {
      exports: '$'
    },
    underscore: {
      exports: '_'
    },
    backbone: {
      deps: ['jquery', 'underscore'],
      exports: 'Backbone'
    },
    sprintf: {
      exports: 'sprintf'
    },
    liveupdate: {
      deps: ['jquery', 'quicksilver'],
      exports: '$'
    },
    jqueryui: {
      deps: ['jquery'],
      exports: '$'
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
    chachiSlider: {
      deps: ['jquery'],
      exports: '$'
    }
  }

});

require([
  'jquery',
  'handlebars',
  'router',
  'chachiSlider'
], function($, Handlebars, Router) {

  var $reportTitleTextarea = $('.report-title').find('textarea');

  // Extensions
  Number.prototype.toCommas = function() {
    return this.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  };

  // Handlebars
  Handlebars.registerHelper('commas', function(context) {
    if (typeof context !== 'number') {
      return context;
    }
    return context.toCommas();
  });

  Handlebars.registerHelper('starray', function(context) {
    var result = '', i = 0, len = context.length;

    if (context.length > 0) {
      for (i=0;i<len;i++) {
        if (i === len -1) {
          result += context[i];
        } else {
          result += context[i] + ', ';
        }
      }
    }

    return result;
  });

  $.fn.noHandleChildren = function() {

    var SearchMenu = function(el) {
      var $el = $(el),
        menuChildren = $el.find('.submenu li').length;

      if (menuChildren === 0) {
        $el.addClass('no-child');
      }
    };

    return this.each(function(index, el) {
      new SearchMenu(el);
    });
  };

  function sectionTitle() {
    var $title = $('.section-title');

    if ($title.text().length > 50) {
      $title.css('font-size', '36px');
    }
  }

  function addClassToBody() {
    var newClass, position;

    position = window.location.pathname.split('/').length - 1;
    newClass = window.location.pathname.split('/')[position];

    $('body').addClass(newClass);
  }

  function goTo(e) {
    $('body, html').animate({
      scrollTop: $('.main-content').offset().top - 49
    }, 500);
    e.preventDefault();
  }

  function autoResizeTextare(el) {
    if (el) {
      $(el).css('height', 0).height(el.scrollHeight);
    }
  }

  $('.btn-go-to-projects').on('click', goTo);

  sectionTitle();
  addClassToBody();
  $('.menu-item').noHandleChildren();

  var $projectBudget = $('#projectBudgetValue');

  if ($projectBudget.text().length > 8) {
    $projectBudget.css({
      'font-size': '35px'
    });
  }

  $('.mod-logos-slider').chachiSlider({
    navigation: false,
    pauseTime: 7000
  });

  $reportTitleTextarea.on('keyup', function(e) {
    autoResizeTextare(e.currentTarget);
  });

  autoResizeTextare($reportTitleTextarea[0]);

  new Router();

});
