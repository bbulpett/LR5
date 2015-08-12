# LR5
_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.alpha. Development environment Ruby 2.2.2 and Rails 5.0.0.alpha on Ubuntu Linux version 14.04._

#### Chapter 2
"Creating Your Own View (hello01)"

	~/projects/hello01/bin$ rails generate controller hello index
(config/routes.rb) Add the following line:

	root 'hello#index'
Save the edited routes.rb file and restart the server

	~/projects/hello01/bin$ rails server

Change app/views/hello/index.html.erb to read as follows:

	<h1>Hello!</h1>
	<p>This is a greeting from app/views/hello/index.html.erb</p>
Save the file and refresh the browser.
"Adding Some Data (hello02)"
app/controllers/hello_controller) Change the index method to read as follows:

	class HelloController < ApplicationController
	  def index
	  	@message="Hello"
	  	@count=3
	  	@bonus="This message came from the controller."
	  end
	end

Then modify app/views/hello/index.html.erb:

	<h1><%= @message %></h1>
	<p>This is a greeting from app/views/hello/index.html.erb</p>
	<p><%= @bonus %></p>
"Adding Logic to the View (hello03)"
(open app/views/hello/index.html.erb)
Change the contents of this file to the following:

	<h1><%= @message %></h1>
	<p>This is a greeting from app/views/hello/index.html.erb</p>
	<% for i in 1..@count %>
		<p><%= @bonus %></p>
	<% end %>
Save the file and refresh the browser.