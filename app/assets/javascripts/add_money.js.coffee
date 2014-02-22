$(document).on "click", ".add_money", (event) ->
  event.preventDefault()
  client_id = $(this).attr('id')
  $.ajax
    type: "POST"
    url: $(this).attr "href"
    data: { 
      money : 1000,
      client_id : client_id
    }
    dataType: "json"
    error: (data) ->
      alert("add_money response error" + data.status + data.balance)
      $("div.current_balance").text("Your balance is " + data.balance + " credits")
    success: (data) ->
      $("div.current_balance").text("Your balance is " + data.balance + " credits")