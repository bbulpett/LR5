# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# The following represents the preferred way to declare a jQuery function in Rails. Note the simplification of the syntax, particularly the first line, where we make use of the CoffeeScript-style function syntax "->". Also noticable is the absence of curly braces to wrap the function or semicolons ending the statements, as you would find with traditional JavaScript.

$(document).on "ready", -> 
   $("input").focus ->
     $(this).parent().addClass("curFocus")
   $("input").blur ->
     $(this).parent().removeClass("curFocus")
