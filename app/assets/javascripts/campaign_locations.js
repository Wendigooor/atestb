
$(document).ready(function(){

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

	// map

	var lat = 35.2475, 
		lon = -100.8189,
		map;
	var mapOptions = {
		zoom: 4,
		center: new google.maps.LatLng(lat, lon)
	};

	map = new google.maps.Map(document.getElementById('map'), mapOptions);

	$('#address_btn').on('click', function() {
		var url = "/campaign_location_points/coordinates";
		var address = $('#address').val();

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
		var new_value = $('#distance').val();
		$("#distance_field").val(new_value);
	});

	$("#add_location_point").on('click', function() {
		var url = "/campaign_location_points";
		var campaign_id = $('#edit_campaign_form').attr('campaign_id');

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
