/* This will contain global javascript for your application */
$(document).ready(function(){
  $('input[type=checkbox][name=watched]').on('change', function(){
    // checked = $(this).get(0).checked;
    // settings = {
    //   dataType: 'script',
    //   type: 'POST',
    //   url: '/episodes/'+
    // }
    $(this).closest('form').submit();
  })
});