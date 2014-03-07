$(document).on "click", ".purchase", (event) ->
  event.preventDefault()
  purchase = $(this).closest('tr').find('input')
  campaign_id = $(this).closest('tr').find('input').attr('class')
  $.ajax
    type: "POST"
    url: $(this).attr "href"
    data: {"purchase":purchase.val(),"campaign_id":campaign_id}
    dataType: "json"
    error: (data) ->
      alert("Purchase response error: status: " + data.status + " reason: " + data.reason + " balance: " + data.balance)
    success: (data) ->
      $("#current_balance").text("Your balance is " + data.balance + " credits")
      $("div." + campaign_id + "purchased").text(data.campaign_purchased)
      $("#purchase_reason").text(data.reason)
