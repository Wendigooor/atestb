
$(document).ready(function(){

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

});
