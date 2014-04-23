'use strict';

(function() {

  function onDocumentReady() {
    $('.chzn-select').chosen();

    $('.select_date').find('select').chosen();
  }

  $(document).ready(onDocumentReady);

}());
