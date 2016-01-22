# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function() {
			$("input").focus(function() {
				$(this).parent().addClass("curFocus")
			});
			$("input").blur(function() {
				$(this).parent().removeClass("curFocus")
			{);
		});