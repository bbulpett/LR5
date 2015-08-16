## LR5

##Chapter 4:

####"Getting Started, Greeting Guests (guestbook01)"

	~/projects$ rails new guestbook01 [--edge --dev]
	~/projects/guestbook01$ bundle install
	
	~/projects/guestbook01$ rails generate controller entries	

(open guestbook01/app/controllers/entries_controller.rb) Add the following method between the lines *class EntriesController < ApplicationController* and *end*:

	def sign_in

	end

Create a new file in the app/views/entries/directory called _sign_in.html.erb_. Edit the file to contain the following code:

	<h1>Hello <%= @name %></h1>
	
	<%= form_tag :action => 'sign_in' do %>
		<p>Enter your name:
		<%= text_field_tag 'visitor_name', @name %></p>

		<%= submit_tag 'Sign in' %>

	<% end %>

(open config/routes.rb)
Add the following line, just before the final `end` statement:

	match ':controller(/:action(/:id(.:format))', via: [:get, :post]
	# This sets up a simple, regular route that will map incoming HTTP requests
	# to the name of a controller in the app. It will also map to an action of
	# that controller, the id of some object to perform the action on, and what 
	# format should be returned - if applicable. The latter 3 bound parameters
	# are optional should the request supply Rails with this criteria.
	#
	# The _via_ argument specifies which HTTP verbs may be matched.

(open guestbook01/app/controllers/entries_controller.rb)
 Add some logic to the *sign_in* method so it reads like this:

	def sign_in
		@name = params[:visitor_name]
	end