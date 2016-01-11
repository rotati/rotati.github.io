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

$(document).ready(function () {
	$('.project').mouseover(function () {
		$(this).css({
		  '-webkit-box-shadow': '3px 3px 6px 0px rgba(50, 50, 50, 0.5)',
		  '-moz-box-shadow':    '3px 3px 6px 0px rgba(50, 50, 50, 0.5)',
		  'box-shadow':         '3px 3px 6px 0px rgba(50, 50, 50, 0.5)',
		});
	});

	$('.project').mouseleave(function () {
		$(this).css({
		  '-webkit-box-shadow': '0 0 0 0 #777',
		  '-moz-box-shadow':    '0 0 0 0 #777',
		  'box-shadow':         '0 0 0 0 #777'
		});
	});

	$('.close-payment-form').submit(function() {
    $('#paymentsolutionform').modal('hide');
	});
});
