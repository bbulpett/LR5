#LR5
###Chapter 18 - Sending Code to the Browser: JavaScript and CoffeeScript

####Sending JavaScript to the Browser

When scaffolding was generated for the *Students* application, CoffeeScript files were created inside the *app/assets/javascripts* folder. In the *students.coffee* file we may add some CoffeeScript, JavaScript, or even jQuery. 

To use regular JavaScript, the file itself should be renamed from *students.coffee* to *students.js*. Rails provides "out of the box" access to the jQuery library by default, so let's take advantage of that. Open *app/assets/javascripts/students.js*. Since we've changed the file type from the default CoffeeScript to plain JavaScript, there is a minor (but very significant) change we must make to the file before we can add our own logic. Notice the block of comments at the top of the file..

		# Place all the behaviors and hooks related to the matching controller here.
		# All this logic will automatically be available in application.js.
		# You can use CoffeeScript in this file: http://coffeescript.org/

It's great that Rails has provided us with this information, but the comments have been formatted for *CoffeeScript* with the hash ("#") symbol. This happens to be an illegal character in JavaScript and will throw an exception if it's in our ".js" file. What's more, Rails will refuse to compile the file if it contains this corrupt syntax. Go ahead and **remove the comments**.

Now we can add the following script to dynamically style a field in the **New Student** form when in focus:

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

####Converting to CoffeeScript



####Remote Control: Basic AJAX Rendering


