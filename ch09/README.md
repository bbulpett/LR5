#LR5

##Chapter 9
###"Developing Model Relationships"

Chapter 9 deals with apps that have multiple tables and how to connect and relate them to one another.

####"Connecting Awards to Students"

At the terminal prompt, create a new rails application:

		rails new students01

Change to the app directory (`cd students01`) and run the following command to create a **student** model with its basic attributes..

		rails generate scaffold student given_name:string middle_name:string family_name:string date_of_birth:date grade_point_average:decimal start_date:date

Now create an additional model with scaffolding..

		rails generate scaffold award name:string year:integer student_id:integer

Notice that we've given the **award** model a "student_id" attribute. This will be used as a foreign key to connect to the **student** model.

####"Establishing the Relationship"

Next, the relationships must be defined in the application's models. In the text editor, open *app/models/student.rb* and insert the following declaration between the `class` and `end` lines:

		has_many :awards

Similarly, the following line must be added to *app/models/award.rb*:

		belongs_to :student

At the terminal, run `rake db:migrate`. The two models are now connected in a very basic *one-to-many* relationship. Starting the Rails server (`rails s`) and navigating to *localhost:3000/students/new*, create a new **student** record.

####"Supporting the Relationship"

The form for generating a new award (*localhost:3000/awards/new*) has a text field for the student associated with the award. One way to ensure that only "existing" students will be entered is to use a **select** (drop-down) list. In *app/views/awards/_form.html.erb*, replace the line `<%= f.number_field :student_id %>` with the following piece of code, which generates a collection of students and organizes them by name:

		<%= f.select :student_id, Student.all.order(:family_name,:given_name).collect {|s| [(s.given_name + " " + s.family_name), s.id]} %>

The above code uses the `all` method of the ActiveRecord query interface to retrieve all student records, sorts them (the `order` method) by last and first name
, and stores them in a collection which is used by the **select** method. Now when creating a new award at *localhost:3000/awards/new*, we can assign it to a particular student. However, when doing so, *app/views/awards/show* displays the integer value of the **:student_id**. This is easily fixed by replacing the `<%= @award.student_id %>` line in the *show* view with the following code:

		<%= @award.student.given_name %> <%= @award.student.family_name %>

And in the *index* view (since it comes from the counter variable of the **each** loop, the **award** has local scope)..
	
		<%= award.student.given_name %> <%= award.student.family_name %>

To further simplify the display of the student's name, add the following method to the *app/models/student.rb*:

		def name
			given_name + " " + family_name
		end

Now we can change the above line in the *show* view to simply read as follows:

		<%= @award.student.name %>

And in the *index* view (again, the **award** variable has local scope)..

		<%= award.student.name %>

Furthermore, the above line we created in *app/views/awards/_form.html.erb* can be simplified:

		<%= f.select :student_id, Student.all.collect {|s| [s.name, s.id]} %>

Refreshing the view in the browser now shows the *name* of the student the award "belongs to", which is more readable for humans.

####"Guaranteeing a Relationship"

When assigning an award to a student it is important, of course, that that student actually exists in the database. Returning to *app/models/award.rb*, we can easily ensure that the student association exists by adding the following validation just after the `belongs_to :student' line:

		validates_associated :student

Quickly test this by running rake db:migrate in the terminal and opening the Rails console (`rails c`). At the prompt, try to create a new award with an *invalid* **:student_id** attribute. Something like this..

		a=Award.new(name: "Best Attitude", year: "2015", student_id: 999).save

Assuming the database contains fewer than 999 users, the console will return **false** and roll back the "save" transaction.
**NOTE:** It is important to note that, although **validates_associated** may be used on either side of the association, *it MUST NOT be used on both sides simultaneously*. This would create a "circular dependency" and an infinie recursion, causing the application to freeze or crash.
