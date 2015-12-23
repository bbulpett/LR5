#LR5
_The following steps were used to recreate the Learning Rails 3 files within Ruby on Rails version 5.0.0.beta1. Development environment Ruby 2.2.2 and Rails 5.0.0.beta1 on Ubuntu Linux version 14.04._
##Chapter 3:

####"Choosing a Layout from a Controller (hello06)"
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

***
<sup>Tested and reconciled with changes made to book text</sup>
