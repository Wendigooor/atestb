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
      #alert("purchase response error" + data.status + data.reason + data.balance)
      $("div.current_balance").text(data.balance)
    success: (data) ->
      #alert("purchase status:" + data.status + " reason:" + data.reason + " balance:" + data.balance + " campaign purchased res:" + data.campaign_purchased)
      $("div.current_balance").text("Your balance is " + data.balance + " credits")
      $("div." + campaign_id + "purchased").text(data.campaign_purchased)
      $("div.purchase_reason").text(data.reason)