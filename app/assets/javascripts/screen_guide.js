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
  })
}