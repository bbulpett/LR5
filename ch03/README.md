# LR5

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

"Creating a Layout for a Controller (hello05)"
(Create a new file in the app/views/layouts folder called hello.html.erb) 
Copy the contents of application.html.erb into the newly created hello.html.erb file.
Remove the contents of the `<title>` tag and replace with the following variable reference:

	<%= @message %>

Add the following line to the space between the `<body>` tag and the `<%= yield %>` statement:

	<p>(using hello layout)</p>

Save changes to the file and refresh the browser.

"Choosing a Layout from a Controller (hello06)"
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