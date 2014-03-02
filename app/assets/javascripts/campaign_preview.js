
$(document).ready(function(){

	$('#campaign_preview').hide();

	$('div[id=campaign_title]').text($('#campaign_caption').val());


	var background_url = $('#preview_button').attr('data-background-url');
	$('#answers, #answers_landscape').css("background-image", "url( /images/" + background_url + " )" );
	$('#answers, #answers_landscape').css("-webkit-background-size", "cover" );
	$('#answers, #answers_landscape').css("-moz-background-size", "cover" );
	$('#answers, #answers_landscape').css("background-size", "cover" );

	var font_size = $('#preview_button').attr('data-font-size');
	$('#campaign_preview').css("fontSize", font_size);

	$( "#preview_button" ).click(function() {
	  
		if ($('#campaign_preview').css('display') == 'none')
		{
			$('#preview_button').text("Hide campaign preview");
			$('#campaign_preview').show();

			var title_color = $('#campaign_title_color').val();
			$('div[id=campaign_title]').css('color', title_color);

			answers_height = $('#portrait_preview').height() - $('#campaign_title').height() - 50;
			answers_landscape_height = $('#landscape_preview').height() - $('#campaign_title').height() - 50;

			var correct_answers = $('#preview_button').attr('data-items-count');
			var type_ad = $('#preview_button').attr('data-type-ad');

			var answers = $('#answers div');
			var answers_landscape = $('#answers_landscape div');

			var answer_height = answers_height / correct_answers;
			var answer_landscape_height = answers_landscape_height / correct_answers;

			for (i = 0; i < answers.length; i++)
			{
				$(answers[i]).hide();
			}

			for (i = 0; i < answers_landscape.length; i++)
			{
				$(answers_landscape[i]).hide();
			}

			for (i = 0; i < correct_answers; i++)
			{
				content = $("#campaign_campaign_items_attributes_" + i + "_content").val();

				$(answers[i]).text(content);
				$(answers_landscape[i]).text(content);

				var border_color = $('#campaign_border_color').val();
				$(answers[i]).css('border-color', border_color);
				$(answers_landscape[i]).css('border-color', border_color);

				$(answers[i]).show();
				$(answers_landscape[i]).show();
				$(answers[i]).height(answer_height);
				$(answers_landscape[i]).height(answer_landscape_height);
			}
		}
		else
		{
			$('#preview_button').text("Show campaign preview");
			$('#campaign_preview').hide();
		}

	});


	$('#locations').hide();

	$( "#locations_button" ).click(function() {
		if ($('#locations').css('display') == 'none')
		{
			$('#locations_button').text("Hide campaign preview");
			$('#locations').show();
		}
		else
		{
			$('#locations_button').text("Show campaign preview");
			$('#locations').hide();
		}
	});

	$('#search_campaign').on('input', function() {
		var url = '/campaigns/search';
		var campaign_id = $(this).val();
		if (campaign_id == "")
		{
			campaign_id = "empty";
		}

		$.ajax({
			type: "GET",
			url: url,
			data: { campaign_id : campaign_id },
			dataType: "json",
			success: function(data) {
				$('#campaigns').html(data.html)
			}
		});
	});

	$('#add_adv_period').click(function(){
		var url = '/adv_periods';
		var start_time = ($('#start_time').timepicker('getHour') * 60 + $('#start_time').timepicker('getMinute')) * 60;
		var end_time = ($('#end_time').timepicker('getHour') * 60 + $('#end_time').timepicker('getMinute')) * 60;
		var day = $('#day').find(":selected").text();
		alert(url + " " + start_time + " " + end_time + " " + day + " " + AUTH_TOKEN)

		$.ajax({
			type: "POST",
			url: url,
			data: {
				authenticity_token: AUTH_TOKEN,
				campaign_id : campaign_id,
				start_time : start_time,
				end_time : end_time,
				day : day
			},
			dataType: "json",
			success: function(data) {
				$('#' + day).html(data.html)
			}
		});
	});

	$(document).on("click", "[id=\"remove_adv_period\"]", function(event) {
		var adv_period_id = $(this).attr('data-adv-period-id');
		var url = '/adv_periods/' + adv_period_id;
		var day = $(this).attr('data-day')

		$.ajax({
			type: "DELETE",
			url: url,
			data: {
				authenticity_token: AUTH_TOKEN,
				adv_period_id : adv_period_id
			},
			dataType: "json",
			success: function(data) {
				$('#' + day).html(data.html);
			}
		});
	});

	$('#start_time').timepicker({
		showLeadingZero: false,
		onSelect: tpStartSelect,
		maxTime: {
			hour: 16, minute: 30
		}
	});

	$('#end_time').timepicker({
		showLeadingZero: false,
		onSelect: tpEndSelect,
		minTime: {
			hour: 9, minute: 15
		}
	});

	function tpStartSelect( time, endTimePickerInst ) {
		$('#end_time').timepicker('option', {
			minTime: {
				hour: endTimePickerInst.hours,
				minute: endTimePickerInst.minutes
			}
		});
	}

	function tpEndSelect( time, startTimePickerInst ) {
		$('#start_time').timepicker('option', {
			maxTime: {
				hour: startTimePickerInst.hours,
				minute: startTimePickerInst.minutes
			}
		});
	}

	var nowTime = new Date();
	$('#start_time').timepicker('setTime', nowTime);
	$('#end_time').timepicker('setTime', nowTime);


	// map

	var lat = 35.2475, 
        lon = -100.8189,
        map;
    var mapOptions = {
      zoom: 4,
      center: new google.maps.LatLng(lat, lon)
    };

    map = new google.maps.Map(document.getElementById('map'),
          mapOptions);

    $('#address_btn').on('click', function() {
      var url = "/campaign_location_points/coordinates";
      var address = $('#address').val();
      if (address == "")
      {
        
      }

      var latitude = $("#latitude");
      var longitude = $("#longitude");

      $.ajax({
        type: "GET",
        url: url,
        data: { address : address },
        dataType: "json",
        success: function(data) {
          if (data != null)
          {
            map.setCenter(new google.maps.LatLng(data[0], data[1]));
            latitude.val(data[0]);
            longitude.val(data[1]);
            map.setZoom(14);
          }
          else
          {
            latitude.val(0.0);
            longitude.val(0.0);
          }
        }
      });
    });

    $("#distance").change(function () {                    
      var newValue = $('#distance').val();
      $("#distance_field").val(newValue);
    });

    $("#add_location_point").on('click', function() {
      var url = "/campaign_location_points";
      var campaign_id = $('#before_answers').attr('data-campaign-id');

      var address = $('#address').val();
      var latitude = $("#latitude").val();
      var longitude = $("#longitude").val();
      var distance = $("#distance").val();

      $.ajax({
        type: "POST",
        url: url,
        data: { 
          address : address,
          campaign_id : campaign_id,
          latitude : latitude,
          longitude : longitude,
          distance : distance,
          authenticity_token: AUTH_TOKEN
        },
        dataType: "json",
        success: function(data) {
          $("#location_points").html(data.html);
        }
      });
    });

    $(document).on("click", "[id=\"remove_location_point\"]", function(event) {
      var location_point_id = $(this).attr('data-location-point-id');
      var url = '/campaign_location_points/' + location_point_id;

      $.ajax({
        type: "DELETE",
        url: url,
        data: {
          authenticity_token: AUTH_TOKEN,
          location_point_id : location_point_id
        },
        dataType: "json",
        success: function(data) {
          $("#location_points").html(data.html);
        }
      });
    });


});
