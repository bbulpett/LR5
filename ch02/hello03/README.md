#LR5

_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.alpha. Development environment Ruby 2.2.2 and Rails 5.0.0.alpha on Ubuntu Linux version 14.04._


##Chapter 2
####"Adding Logic to the View (hello03)"

(open app/views/hello/index.html.erb)
Change the contents of this file to the following:

    <h1><%= @message %></h1>
    <p>This is a greeting from app/views/hello/index.html.erb</p>
    <% for i in 1..@count %>
    	<p><%= @bonus %></p>
    <% end %>
	
Save the file and refresh the browser.

***
<sup>Tested and reconciled with changes made to book text</sup>