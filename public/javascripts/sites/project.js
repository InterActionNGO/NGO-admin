


  $('select').change(function(){
    $(this).closest('form').submit();
  });
      /* MENU HACK POSITIONING*/
      $('div#header div.left').width(680);

      var video_total = 0;
      var video_count = 0;

      $(document).ready( function() {

				//Collapsable list of donors
        $('ul.donor_list').each(function(index,element){
          var list_size_compress = $(element).height();
          $(element).find('li.out').css('display','none');
          var list_size = $(element).height();
          $(element).height(list_size);
          $(element).css('overflow','hidden');
          $(element).parent().children('a.more').attr('title',list_size_compress);
          $(element).parent().children('a.more').click(function(){
            $(this).parent().find('li.out').css('display','block');
            var size = $(this).attr('title') + 'px';
            $(this).parent().find('ul').animate({height: size},500, function(){
              $(this).parent().find('a.more').remove();
            });
          });
        });

        //Number of men for painting
		var people_width = $('span.people_amount').attr('estimate');

		  people_width = custLog(Number(people_width),10);
        $('span.people_amount').width(255*(people_width/7));
		    if ($('span.people_amount').width() == 0) $('span.people_amount').width(5);
        $('span.people_amount').css('display','block');

        $('p.estimate').text(parseInt($('p.estimate').text()).toMoney(0,'.',','));
        $('p.estimate').html($('p.estimate').text() + '<sup>(target)</sup>');


        //If left part is bigger than float right
        if ($('div#project div.float_left').height() < $('div#project div.right').height()) {
          var offset =  $('div#project div.right').height() - $('div#project div.float_left').height();
          $('div#project div.float_left').append('<div class="block margin"></div>');
          $('div#project div.float_left div.block:last').height(offset);
          $('div#project div.outer_float').height($('div#project div.float_left').height()-40);
          $('div#project div.left').height($('div#project div.float_left').height()-40);
        } else {
          $('div#project div.outer_float').height($('div#project div.float_left').height()-40);
          $('div#project div.left').height($('div#project div.outer_float').height());
        }

        $('div#completed').css('bottom','-10px');

        //Days left effect
        var d = new Date();
        var total_days = daydiff(parseDate($('p.first_date').text()), parseDate($('p.second_date').text()));
        var days_completed = daydiff(parseDate($('p.first_date').text()), parseDate((d.getMonth()+1)+'/'+(d.getDate())+'/'+(d.getFullYear())));


        if (days_completed >= total_days){
            $('div.timeline p').text('COMPLETED');
            $('div#completed').css('display','inline');
        }

        $('div.timeline span').width((days_completed*237)/total_days);



        if ($('div.galleryStyle img').size()>0) {
          $('div.loader_gallery').css('top',$('div.galleryStyle').position().top+1+'px');
          $('a.video').css('top',$('div.galleryStyle').position().top+150+'px');
          $('div.loader_gallery').show();
          $('div.mamufas').remove();
          startGalleria();
        }

      });



      function parseDate(str) {
          var mdy = str.split('/')
          return new Date(mdy[2], mdy[0]-1, mdy[1]);
      }


      function daydiff(first, second) {
          return (second-first)/(1000*60*60*24)
      }


      function startGalleria() {
        if ($('div.galleryStyle').length>0) {
          var r = ($.browser.msie)? "?r=" + Math.random(10000) : "";
          Galleria.loadTheme('/javascripts/plugins/galleria.classic.js' + r);
          $('div.galleryStyle').galleria({thumbnails:false, preload:2,autoplay:5000,transition:'fade',show_counter:'false'});
          $('div.loader_gallery').delay(300).fadeOut();
        }
      }


      function playVideo(video_id) {
        $('div.loader_gallery img').remove();
        $('div.loader_gallery p').remove();
        $('div.loader_gallery div.video_player').show();
        $('div.loader_gallery div.video_player').html(video_players[video_id]);
        $('div.loader_gallery div.video_player').each(function(index,element){
          if (index!=0) {
            $(element).remove();
          }
        });
        $('div.loader_gallery').fadeIn();
      }

	function custLog(x,base) {
		return (Math.log(x))/(Math.log(base));
	}

	function custRound(x,places) {
		return (Math.round(x*Math.pow(10,places)))/Math.pow(10,places)
	}

	Number.prototype.toMoney = function(decimals, decimal_sep, thousands_sep)
  {
     var n = this,
     c = isNaN(decimals) ? 2 : Math.abs(decimals), //if decimal is zero we must take it, it means user does not want to show any decimal
     d = decimal_sep || ',', //if no decimal separetor is passed we use the comma as default decimal separator (we MUST use a decimal separator)

     /*
     according to [http://stackoverflow.com/questions/411352/how-best-to-determine-if-an-argument-is-not-sent-to-the-javascript-function]
     the fastest way to check for not defined parameter is to use typeof value === 'undefined'
     rather than doing value === undefined.
     */
     t = (typeof thousands_sep === 'undefined') ? '.' : thousands_sep, //if you don't want ot use a thousands separator you can pass empty string as thousands_sep value

     sign = (n < 0) ? '-' : '',

     //extracting the absolute value of the integer part of the number and converting to string
     i = parseInt(n = Math.abs(n).toFixed(c)) + '',

     j = ((j = i.length) > 3) ? j % 3 : 0;
     return sign + (j ? i.substr(0, j) + t : '') + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : '');
  }
