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

$(document).ready(function () {
	var website = document.getElementById('website');
    $('#website').keyup(function() {
        var $th = $(this);
        if (isValidUrl($th.val())==-1){
        	website.setCustomValidity("Please enter a valid URL. Ex: example.com")
        } else {
        	website.setCustomValidity('')
        }

    });
});

function isValidUrl(url){
  var myVariable = url;
  if(/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/i.test(myVariable)) {
    return 1;
  } else {
    return -1;
  }
}
