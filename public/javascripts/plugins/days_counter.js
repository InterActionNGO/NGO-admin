(function($) {

  $('document').ready(function(){

    var date1,
        date2,
        daysCounter,
        timeDiff,
        diffDays;

      daysCounter = $('#remaining-days');

      function differentBtwDates () {
        date1 = new Date();
        date2 = new Date("6/11/2014");
        timeDiff = Math.abs(date2.getTime() - date1.getTime());
        diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24)) - 1;

        daysCounter.append(diffDays);
      }

      differentBtwDates();
  });

})( jQuery );
