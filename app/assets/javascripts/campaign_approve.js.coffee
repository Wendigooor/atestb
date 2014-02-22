$(document).on "click", ".approve", (event) ->
  event.preventDefault()
  campaign_id = $(this).closest('tr').find('td').attr('class')
  #alert(campaign_id)
  $.ajax
    type: "POST"
    url: $(this).attr "href"
    data: {"campaign_id":campaign_id}
    dataType: "json"
    error: (data) ->
      #alert("error/ campaign started error")
    success: (data) ->
      #alert("success/ please reload page /campaign started:" + data.campaign_started)
      #alert("Success. Please reload page")
      location.reload();