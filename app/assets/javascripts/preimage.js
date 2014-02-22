function uploadFile(input) {         
if (input.files && input.files[0]) {            

	 var reader = new FileReader();              
	 reader.onload = function (e) {
	 	$(input).closest('fieldset').children("img").attr('src', e.target.result);
	 };               
	 
	 reader.readAsDataURL(input.files[0]);        
	 }     
}