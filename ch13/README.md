#LR5
##Chapter 13 - Sessions and Cookies

The exercises in this chapter build on the completed *guestbook02* app from Chapter 4. Completed code for the following can be found in *ch13/guestbook11*.

####Getting Into and Out of Cookies

Open *app/controllers/entries_controller.rb* and modify the `sign_in` method with the following content:

		class EntryController < ApplicationController
			def sign_in
				@previous_name = cookies[:name]
				@name = params[:visitor_name]
				cookies[:name] = @name
			end
		end

The first line gets the previous name from the cookie so it can be displayed. Second, the new name (from the form) is stored in the `@name` variable. Lastly, the name is stored to a cookie to be transmitted to the browser. Now some code can be added to *app/views/entry/sign_in.html.erb* to report the previous name to the user:


		<h1>Hello <%= @name %></h1>
		<%= form_tag :action => 'sign_in' do %>
			<p>Enter your name:
			<%= text_field_tag 'visitor_name', @name %></p>

			<%= submit_tag 'Sign in' %>
		<% end %>
		<% unless @previous_name.blank? %>
			<p>Hmmm... the last time you were here, you said you were <%= @previous_name %>.</p>
		<% end %>

To see this in action and monitor the cookies, navigate to the page in a browser while monitoring the "Resources" tab of the browser's developer tools. Refer to the text for this chapter and/or the browser documentation for more on this.

####Storing Data Between Sessions

The remainder of the chapter is a continuation of the previous section. Code for this portion is available in ch13/guestbook12. 

