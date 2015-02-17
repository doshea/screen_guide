// Turbolinks-y way of ensuring that this JS is ready
document.addEventListener('page:change', ready_stuff);

function ready_stuff(){
  $('body').on('change', 'input[type=checkbox][name=watched]', function(){
    $(this).closest('form').submit();
  })
  $('body').on('change', 'input[type=checkbox][name=mass_watch]', function(){
    var table = $(this).closest('table');
    if(this.checked){
      var targets = table.find('input[type=checkbox][name=watched]:not(:checked)');
    } else {
      var targets = table.find('input[type=checkbox][name=watched]:checked');
    }
    targets.click();
  });
  $('.episode').on('click','.watch-mark',function(e){
    var episode = $(this).closest('.episode');
    episode.toggleClass('watched');
    var list = $(this).closest('ol')
    $('#queue_counter').text(list.children('li:not(.watched)').length);
    
  });
  $('.show').on('click','.follow-container',function(e){
    var show = $(this).closest('.show');
    show.toggleClass('followed');
  });
  global.ready();
}