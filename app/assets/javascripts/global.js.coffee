window.global =
  ready: ->
    $('nav').on('keyup', '#query', global.live_search)

  live_search: ->
    query = $('#query').val()
    if query.length < 3
      $('#live-results').hide()
    else
      settings =
        dataType: 'script'
        type: 'GET'
        url: "/live_search"
        data: {query: query}
      $.ajax(settings)