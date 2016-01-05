# LR5

##Chapter 4

####"Keeping Track: A Simple Guestbook (guestbook02)"
Run this command at the terminal:

	~/projects/guestbook02$ rails generate model entry

(open db/migrate/<timestamp>_create_entries.rb)
Add the following entry to the "do" loop (right above "t.timespamps"):

	t.string :name

Run this command at the terminal:

	~/projects/guestbook02$ rake db:migrate
	
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
