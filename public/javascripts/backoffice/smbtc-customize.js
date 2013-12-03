(function() {

  $.fn.comboSelect = function() {

    var ComboSelect = function(element) {

      console.log(element);

      this.el = element;
      this.$el = $(element);

      this.init();

    };

    ComboSelect.prototype.init = function() {

      console.log(this);

    };

    this.each(function() {

      new ComboSelect(this);

    });

  };

  function onDocumentReady() {

    $('.combo-select').comboSelect();

  }

  $(document).ready(onDocumentReady);

}());
