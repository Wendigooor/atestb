
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

});
