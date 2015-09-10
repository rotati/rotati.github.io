var d = document.getElementById("alert-msg");

jQuery(function($) {

	//Goto Top
	$('.gototop').click(function(event) {
		 event.preventDefault();
		 $('html, body').animate({
			 scrollTop: $("body").offset().top
		 }, 500);
	});
	//End goto top

});

$(document).ready(function () {
	//Ajax contact
	var $form = $("form");

	$form.submit(function () {
			$.ajax({
				type: "POST",
				dataType: 'json',
				url: $form.attr("action"),
				data: $form.serialize(),
			});
			$form[0].reset();

			d.style.display ="block";
			setInterval(function(){hideMessage()},6000);

			function hideMessage() {
				document.getElementById("alert-msg").style.display = "none";
			}

		return false;
	});
});
