$(document).on "click", ".add_credits", (event) ->
  event.preventDefault()
  client_id = $(this).attr('id')
  $.ajax
    type: "POST"
    url: $(this).attr "href"
    data: { 
      credits : 1000,
      client_id : client_id
    }
    dataType: "json"
    error: (data) ->
      alert("credits response error" + data.status + data.balance)
      $("#current_balance").text("Your balance is " + data.balance + " credits")
    success: (data) ->
      $("#current_balance").text("Your balance is " + data.balance + " credits")