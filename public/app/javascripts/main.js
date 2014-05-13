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
    form: '../vendor/jquery-form/jquery.form'
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
    }
  }

});

require([
  'jquery',

  'models/report',

  'views/clusters',
  'views/map',
  'views/filters',
  'views/menu-fixed',
  'views/downloads',
  'views/embed-map',
  'views/search',
  'views/layer-overlay',
  'views/timeline',
  'views/report-form'
], function($, ReportModel) {

  var ClustersView = arguments[2],
    MapView = arguments[3],
    FiltersView = arguments[4],
    MenuFixedView = arguments[5],
    DownloadsView = arguments[6],
    EmbedMapView = arguments[7],
    SearchView = arguments[8],
    LayerOverlayView = arguments[9],
    TimelineView = arguments[10],
    ReportForm = arguments[11];

  var reportModel = new ReportModel();

  new ClustersView();
  new MapView();
  new FiltersView();
  new MenuFixedView();
  new DownloadsView();
  new EmbedMapView();
  new SearchView();
  new LayerOverlayView();
  new TimelineView();
  new ReportForm({
    model: reportModel
  });

  var scrollTop,
    categoriesSelector = $('.categories-selector'),
    menu = $('.mod-categories-selector .menu'),
    elementOffset = (categoriesSelector.length > 0) ? categoriesSelector.offset().top : 0;

  function sectionTitle() {
    var $title = $('.section-title');

    if ($title.text().length > 50) {
      $title.css('font-size', '36px');
    }
  }

  function fixCategoriesSelector() {
    if (categoriesSelector.length === 0) {
      return false;
    }

    scrollTop = $(window).scrollTop();

    if (scrollTop > elementOffset) {
      categoriesSelector.addClass('is-fixed');
      menu.removeClass('mod-go-up-menu');
      menu.addClass('mod-drop-down-menu');
      $('.layout-sidebar, .layout-content').css({
        marginTop: 50
      });
    } else {
      categoriesSelector.removeClass('is-fixed');
      menu.addClass('mod-go-up-menu');
      menu.removeClass('mod-drop-down-menu');
      $('.layout-sidebar, .layout-content').css({
        marginTop: 0
      });
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
      scrollTop: $('.layout-content').offset().top - 109
    }, 500);
    e.preventDefault();
  }

  $('.click-to-see-btn').on('click', goTo);

  sectionTitle();
  addClassToBody();
  window.onscroll = fixCategoriesSelector;

});
