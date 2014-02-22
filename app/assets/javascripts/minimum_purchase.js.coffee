$(document).on "click", ".minimal_purchase", (event) ->
  event.preventDefault()
  purchase = $(this).parent().find('input').val()
  $.ajax
    type: "POST"
    url: $(this).attr "href"
    data: {"minimal_purchase":purchase}
    dataType: "json"
    error: (data) ->
      location.reload();
    success: (data) ->
      location.reload();