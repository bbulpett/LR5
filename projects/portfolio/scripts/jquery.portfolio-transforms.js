// Transforms home page elements on click of avatar image
$(function() {
            $( "#avatar" ).click(function() {
            	if ( $( "#hidden-nav" ).is(":hidden")){
					$( this ).animate( { "top": "-143px", "width": "70px", "height": "70px" }, 480 );
	            	$( "#hidden-nav" ).show( "fade" );
	            }
	            else {
					$( this ).animate( { "top": "0px", "width": "240px", "height": "240px" }, 640 );
	            	$( "#hidden-nav" ).hide("puff");
	            }
				return false;
            });
         });
