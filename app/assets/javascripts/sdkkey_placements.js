$(document).ready(function() {

	$('input[id=sdkkey_placements_checkbox]').change(function(){

		var url = '/sdkkeys/update_placements'
		var sdkkey_id = $(this).attr('data-sdkkey-id');
		var placement_id = $(this).attr('data-placement-id');
		var checked = $(this).is(':checked');

		$.ajax({
			type: "GET",
			url: url,
			data: {
				sdkkey_id : sdkkey_id,
				placement_id : placement_id,
				checked : checked
			},
			dataType: "json",
			success: function(data){
				//alert('success');
			}
		});
	});
});
