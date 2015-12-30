#LR5

##Chapter 11
###"Debugging"
This chapter explores the many debugging tools that Rails provides and builds on the _student03_ application from chapter 9. Copy and rename this application as _ch11/students05_. Alternatively, a new Rails app can be created named _students05_.

####Creating Your Own Debugging Messages
In the text editor, open _app/views/students/show.html.erb_ and locate the commented lines towards the bottom of the markup. Un-comment the `<%= @student %>` line and refresh the browser to view the raw output. It will look something like "**#<Student:0x007f6e14b19318>**".

Next, try un-commenting the next block of markup in the _show_ view: `<%= debug(@student) %>`. Now when the view is refreshed, we can see a very detailed collection of attributes for the **student** object.


<sup>See text for explanation of how to generate YAML-formatted output using the "debug" method</sup>

####Raising Exceptions
A brute-force way to show a YAML dump of attributes is to deliberately **raise** an exception from the controller. In *app/controllers/award_controller.rb*, locate the `show` method and add a raise method like this:

		def show
			raise @award.to_yaml
		end

Now, navigating to the show page for an award (*localhost:3000/students/1/awards/1* for example) displays a **"RuntimeError"**, along with detailed information of the award object (albeit in an unattractive format). Keep in mind, of course, that debugging methods such as these should **never** be used in a production environment.

<sup>See text for explanation of how to use the "raise" method in the controller to deliberately raise an exception for the purposes of inspecting an element.</sup>

####Logging
Rails provides a generous amount of information in the *log* files. One may instantiate the **logger** object from any model, controller, or view. In the **student** controller (*app/controllers/students_controller.rb*), call the `info` method from within the student's `create` method as follows:

		respond_to do |format|
		if @student.save
			format.html { redirect_to @student, notice: 'Student was successfully created.' }
			format.json { render :show, status: :created, location: @student }

			# Send a message to the log file
			logger.info '********** A NEW STUDENT WAS CREATED! **********'
		else
		...

It helps to make the message stand out (as shown here with all-caps and asterisks) as the log file in *log/development.log* contains a **huge** amount of information. Now when a new student is created and saved, the above message will be added to the log file when the database transaction is complete. The message will also be displayed at the terminal that is running the Rails server.

<sup>See text for explanation of how to output specific information to the Rails log files.</sup>

####Working with Rails from the Console
<sup>See text for a detailed tutorial of how to use the Rails console to work with the application and its objects, including an explanation of how to examine individual http requests.</sup>

####Debug and Debugger

