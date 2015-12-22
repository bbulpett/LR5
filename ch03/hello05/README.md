#LR5
_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.alpha. Development environment Ruby 2.2.2 and Rails 5.0.0.alpha on Ubuntu Linux version 14.04._
##Chapter 3:

####"Creating a Layout for a Controller (hello05)"
(Create a new file in the app/views/layouts folder called hello.html.erb) 
Copy the contents of application.html.erb into the newly created hello.html.erb file.
Remove the contents of the `<title>` tag and replace with the following variable reference:

	<%= @message %>

Add the following line to the space between the `<body>` tag and the `<%= yield %>` statement:

	<p>(using hello layout)</p>

Save changes to the file and refresh the browser.

***
<sup>Tested and reconciled with changes made to book text</sup>