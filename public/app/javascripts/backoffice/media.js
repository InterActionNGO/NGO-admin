
  $(document).ready( function() {

    //add caption or edit
    $('p.caption a').click(function(ev){
      $(this).parent().hide();
      $(this).parent().parent().find('div.caption').show();
    });
  });
