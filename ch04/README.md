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

The "sign in" page can now be viewed in the browser at localhost:3000/entries/sign_in

####"Keeping Track: A Simple Guestbook (guestbook02)"
Run this command at the terminal:

	~/projects/guestbook02$ rails generate model entry

(open db/migrate/<timestamp>_create_entries.rb)
Add the following entry to the "do" loop (right above "t.timespamps"):

	t.string :name

Run this command at the terminal:

	~/projects/guestbook02$ rake db:migrate

(open app/controllers/entries_controller)
Add the following method to the controller:

	private
	def entry_params
		params.require(:entry).permit(:name)
	end

The preceding method is known to Rails as a "strong parameter" (or "strong param"). It tells Rails that it's only allowed to set values for the *:name* attribute of the Entry model. Older versions of Rails required the method *attr_accessible* to be defined in the model itself.
	
Now change the *sign_in* method to read like this:

	def sign_in
		@name = params[:visitor_name]
	  unless @name.blank?
		@entry = Entry.create({:name => @name})
	  end
	end

NOTE: If entries were made prior to editing the *sign_in* method code, they can be dropped by stopping the server (CTRL + C) and running `rake db:rollback` and then `rake db:migrate`. Entering `rake db:migrate:redo` will also work.

The application is now ready to accept name entries. One at a time, enter names into the text field and click "Sign In".
Still in the *entries_controller*, create an array within the *sign_in* method that will hold all of the Entry instances:

	@entries = Entry.all

(open app/views/entries/sign_in.html.erb)
To display the contents of the above array, append the following code to the view:

	<p>Previous visitors:</p>
	<ul>
	<% @entries.each do |entry| %>
		<li><%= entry.name %></li>
	<% end %>
	</ul>

Restart the server and refresh the browser.

***
<sup>Tested and reconciled with changes made to book text</sup>
