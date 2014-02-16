// Turbolinks-y way of ensuring that this JS is ready
document.addEventListener('page:change', ready_stuff);

function ready_stuff(){
  $('body').on('change', 'input[type=checkbox][name=watched]', function(){
    $(this).closest('form').submit();
  })
}

