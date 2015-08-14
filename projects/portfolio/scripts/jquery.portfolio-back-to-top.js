// Control behavior of "back to top" button
$(function() {
		var offset = 250;
	    var duration = 300;
	    $(window).scroll(function() {
	        if ($(this).scrollTop() > offset) {
	            $('.back-to-top').show( "fade" );
	        } else {
	            $('.back-to-top').hide( "puff" );
	        }
	    });
	 
	    $('.back-to-top').click(function(event) {
	        event.preventDefault();
	        $('html, body').animate({scrollTop: 0}, duration);
	        return false;
	    })
	});