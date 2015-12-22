#LR5

_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.alpha. Development environment Ruby 2.2.2 and Rails 5.0.0.alpha on Ubuntu Linux version 14.04._

## Chapter 3:

#### "I Want My CSS / Specifying Stylesheets (hello04)"

(open app/assets/stylesheets/hello.scss) Add the following CSS rules:

	body { font-family: sans-serif;}

	h1 { font-family: serif;
		font-size: 24pt;
		font-weight: bold;
		color: #F00;
		}
		
Save the updated stylesheet and refresh browser window.

#### "Creating a Layout for a Controller (hello05)"
(Create a new file in the app/views/layouts folder called hello.html.erb) 
Copy the contents of application.html.erb into the newly created hello.html.erb file.
Remove the contents of the `<title>` tag and replace with the following variable reference:

	<%= @message %>

Add the following line to the space between the `<body>` tag and the `<%= yield %>` statement:

	<p>(using hello layout)</p>

Save changes to the file and refresh the browser.

#### "Choosing a Layout from a Controller (hello06)"
(open app/controllers/hello_controller.rb) Add a layout call so the controller now reads as follows:

	class HelloController < ApplicationController

		layout "standardLayout"

		def index
			@message="Hello!"
			@count=3
			@bonus="This message came from the controller."
		end
	end

Now create a new html.erb file in the app/views/layouts folder called standardLayout.html.erb. Paste the contents of the _hello.html.erb_ layout into the newly created file and change the contents of the paragraph tag to the following:

	<p>(using standard layout)</p>

Save the new file and refresh the browser to see changes.

#### "Sharing Template Data with the Layout (hello07)"
(open app/views/hello/index.html.erb) Add the following HTML structure below the existing code:

	<% content_for(:list) do %>
		<ol>
			<% for i in 1 ..@count %>
			<li><%= @bonus %></li>
			<% end %>
		</ol>
	<% end %>

(open app/layouts/hello.html.erb) Add the statement `<%= yield :list %>` to the area just below the `<body>` tag so that the body contents read as follows:

	<body>
	<%= yield :list %>
	<!-- layout will incorporate view -->
	<%= yield %>
	</body>

Save the file and refresh the browser to see the ordered list of the bonus message at the top of the viewport.

## IMPORTANT NOTE:
"Setting a Default Page" has been intentionally omitted. The default page has already been set in Chapter 1 (hello01), where the line `root 'hello#index'` defined the default page (root) of the site. Rails 5 no longer uses the syntax _`root :to => "hello#index"`_.

***
<sup>Tested and reconciled with changes made to book text</sup>