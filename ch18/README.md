#LR5
###Chapter 18 - Sending Code to the Browser: JavaScript and CoffeeScript

####Sending JavaScript to the Browser

When scaffolding was generated for the *Students* application, CoffeeScript files were created inside the *app/assets/javascripts* folder. In the *students.coffee* file we may add some CoffeeScript, JavaScript, or even jQuery. To use regular JavaScript, the file itself should be renamed to *students.js* instead of *students.coffee*. 

Add the following script to dynamically style a field in the **New Student** form when in focus:

		$(document).ready(function() {
			$("input").focus(function() {
				$(this).parent().addClass("curFocus")
			});
			$("input").blur(function() {
				$(this).parent().removeClass("curFocus")
			{);
		});

Save the file and open the related stylesheet, *app/assets/stylesheets/students.scss*. Add the `curFocus` class to define how to style the focused form field...

		div.curFocus {
			backgorund: #FDECB2;
			@include bodyshadow;
			width: 250px;
		}

A bit of padding should also be added to the `field` class to allow for the shadowing effect.

		div.field {
			padding: 10px;
		}
