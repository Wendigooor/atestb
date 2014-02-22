
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
				text_url = $("#campaign_campaign_items_attributes_" + i + "_textUrl").val();

				if (type_ad == 0)
				{
					$(answers[i]).text(text_url);

					$(answers_landscape[i]).text(text_url);
				}
				else
				{
					$(answers[i]).css("background-image", "url( /images/" + text_url + " )" );
					$(answers[i]).css("background-repeat", "no-repeat" );
					$(answers[i]).css("background-position", "center" );
					$(answers[i]).css("-webkit-background-size", "100% auto" );
					$(answers[i]).css("-moz-background-size", "100% auto" );
					$(answers[i]).css("background-size", "contain" );

					$(answers_landscape[i]).css("background-image", "url( /images/" + text_url + " )" );
					$(answers_landscape[i]).css("background-repeat", "no-repeat" );
					$(answers_landscape[i]).css("background-position", "center" );
					$(answers_landscape[i]).css("-webkit-background-size", "100% auto" );
					$(answers_landscape[i]).css("-moz-background-size", "100% auto" );
					$(answers_landscape[i]).css("background-size", "contain" );
				}

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




	$("#before_campaigns").change(function(event) {
		event.preventDefault();
		var campaign_id = $(this).children("option").filter(":selected").val();
	 	var items_url = "/campaigns/" + campaign_id + "/campaign_items";
	 	var td_answers = $("#td_answers").html('')

		table = $("<table>")

		$.ajax({
			type: "GET",
			url: items_url,
			dataType: "json",
			success: function(data) {
				$(data).each(function(i, el) {
					var checked = false;
					var value = el[0];
					$('#before_answers_ids option').each(function(){
						if (this.value == value || value == "") {
							checked = true;
							return false;
						}
					});

					tr = $("<tr>")
					td = $("<td>")
					td.append($("<input type=\"checkbox\" id=\"campaign_answer\" style='width:15px'>").attr('value', el[0]).attr('checked', checked).text(el[1]));
					td_answer = $("<td>")
					td_answer.append(el[1]);


					tr.append(td)
					tr.append(td_answer)
					table.append(tr)
				});
			}
		});

		td_answers.html(table);
	});

	var s_ids = $('#before_answers_ids')

	$(document).on("change", "[id=\"campaign_answer\"]", function(event) {

		$("[id=\"campaign_answer\"]").each(function() {
			var value = this.value;
			var exists = false;

			if ( this.checked )
			{
				$('#before_answers_ids option').each(function(){
					if (this.value == value || value == "") {
						exists = true;
						return false;
					}
				});

				if (!exists && !(value == ""))
				{
					s_ids.append(new Option( value ) );
				}
			}
			else
			{
				$('#before_answers_ids option').each(function(){
					if (this.value == value || value == "") {
						exists = true;
						this.remove();
						return false;
					}
				});
			}
		});

		s_ids.trigger( "change" );
	});

	$( "#edit_campaign_form" ).submit(function( event ) {
		$('#before_answers_ids').append($("<option>").attr('value', 0).text(0));
		$('#before_answers_ids option').each(function(){
			this.selected = true;
		});
	});

	var campaign_id = $('#before_answers').attr('data-campaign-id');
	if (campaign_id != undefined)
	{
		var before_answers_url = "/campaigns/" + campaign_id + "/before_answers"
	}

	update_before_answers();

	function update_before_answers()
	{
		$('#before_answers_ids option').each(function(){
			this.remove();
		});

		$.ajax({
			type: "GET",
			url: before_answers_url,
			dataType: "json",
			success: function(data) {
				console.log(data)
				$(data).each(function(i, el) {
					$('#before_answers_ids').append($("<option>").attr('value', el[0]).text(el[1]));
				});
				s_ids.trigger( "change" );
			}
		});
	}

	$('#before_answers_ids').change( function() {
		var answers_ids = [];
		$("#before_answers_ids option").each(function() {
			answers_ids.push(this.value);
		});

		var url = "/campaigns/" + campaign_id + "/before_answers_table";

		$.ajax({
			type: "GET",
			url: url,
			data: { answers_ids : answers_ids },
			dataType: "json",
			success: function(data) {
				$('#td_before_answers').html(data.html)
			}
		});
	});




	$( "#datepicker_from" ).datepicker({ dateFormat: 'yy-mm-dd' });
	$( "#datepicker_to" ).datepicker({ dateFormat: 'yy-mm-dd' });




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


	$(document).on("click", "[id=\"remove_campaign_before\"]", function(event) {
		var url = '/campaigns/' + campaign_id + '/remove_campaign_before';
		var campaign_before_remove_id = $(this).attr('data-campaign-before-remove-id');

		$.ajax({
			type: "GET",
			url: url,
			data: { campaign_before_remove_id : campaign_before_remove_id },
			dataType: "json",
			success: function(data) {
				$('#td_before_answers').html(data.html)
				update_before_answers();
				$("#before_campaigns").trigger("change")
			}
		});
	});

});
