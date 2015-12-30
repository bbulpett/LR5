#LR5

##Chapter 11
###"Debugging"
This chapter explores the many debugging tools that Rails provides and builds on the _student03_ application from chapter 9. Copy and rename this application as _ch11/students05_. Alternatively, a new Rails app can be created named _students05_.

####Creating Your Own Debugging Messages
In the text editor, open _app/views/students/show.html.erb_ and locate the commented lines towards the bottom of the markup. Un-comment the `<%= @student %>` line and refresh the browser to view the raw output. It will look something like "**#<Student:0x007f6e14b19318>**".

Next, try un-commenting the next block of markup in the _show_ view: `<%= debug(@student) %>`. Now when the view is refreshed, we can see a very detailed collection of attributes for the **student** object.

<sup>See text for explanation of how to generate YAML-formatted output using the "debug" method</sup>

####Raising Exceptions
<sup>See text for explanation of how to use the "raise" method in the controller to deliberately raise an exception for the purposes of inspecting an element.</sup>

####Logging
<sup>See text for explanation of how to output specific information to the Rails log files.</sup>

####Working with Rails from the Console
<sup>See text for a detailed tutorial of how to use the Rails console to work with the application and its objects, including an explanation of how to examine individual http requests.</sup>

####Debug and Debugger


