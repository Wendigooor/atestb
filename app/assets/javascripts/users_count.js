// $(document).ready(function() {

// 	users_count();

// 	$("input[name='campaign[age_range_ids][]']:checked").change(function ()
// 	{
// 		users_count();
// 	});

// 	$("input[name='campaign[gender]']:checked").change(function ()
// 	{
// 		users_count();
// 	});

// 	$("input[name='campaign[target_device]']:checked").change(function ()
// 	{
// 		users_count();
// 	});

// 	$(document).on("click", "[id=\"remove_campaign_before\"]", function(event) {
// 		users_count();
// 	});

// 	$('#before_answers_ids').change( function() {
// 		users_count();
// 	});

// 	function users_count()
// 	{
// 		var gender = $.map($("input[name='campaign[gender]']:checked"), function(e, i) {
// 			return +e.value;
// 		});

// 		var age = $.map($("input[name='campaign[age_range_ids][]']:checked"), function(e, i) {
// 			return +e.value;
// 		});

// 		var target_device = $.map($("input[name='campaign[target_device]']:checked"), function(e, i) {
// 			return +e.value;
// 		});

// 		var campaign_id = $('#before_answers').attr('data-campaign-id');

// 		var url = '/users/count';

// 		$.ajax({
// 			type: "GET",
// 			url: url,
// 			data: {
// 				gender : gender,
// 				age : age,
// 				target_device : target_device,
// 				campaign_id : campaign_id
// 			},
// 			dataType: "json",
// 			error: function(data) {
// 				$('#users_count').text("users count response error");
// 			},
// 			success: function(data) {
// 				$('#users_count').text("Users count: " + data.count);
// 			}
// 		});

// 	}

// });
