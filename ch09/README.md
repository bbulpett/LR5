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

Assuming the database contains fewer than 999 students, the console will return **false** and roll back the "save" transaction.

**NOTE:** It is important to note that, although **validates_associated** may be used on either side of the association, *it MUST NOT be used on both sides simultaneously*. This would create a "circular dependency" and an infinie recursion, causing the application to freeze or crash.

###"Connecting Students to Awards"
####"Removing Awards When Students Disappear"

As the students-awards association currently stands, the removal of a student would create an *orphaned record* in the Awards table. Adding the following option to the Student model's **has_many** declaration solves this problem:

		has_many :awards, dependent: :destroy

The destruction of a **student** record will now cascade, destroying all of the student's awards along with it.

####"Counting Awards for Students"

In order to display the amount of awards have been awarded to each student, open *app/views/students/index.html.erb* add a new column to the table. Add a table heading after the `<th>Start date</th>` line:

		<th>Awards</th>

Just after the `<td><%= student.start_date %></td>' line, add the following table cell:

		<td><%= student.awards.count %></td>

The student's awards are accessible to the student model due to the *has_many* relationship. Adding the following table to *app/views/students/show.html.erb*, just before the ending `<%= link_to ... %>` code, to handsomely display the student's awards...

		<h3>Awards</h3>
		<table>
			<tr>
				<th>Name</th>
				<th>Year</th>
				<th>Student</th>
			</tr>
		<% for award in @student.awards %>
			<tr>
				<td><%= award.name %></td>
				<td><%= award.year %></td>
				<td><%= award.student.name %></td>
			</tr>
		<% end %>
		</table>

Visiting *localhost:3000/students* and navigating to a student's "show" page will render a table of their awards along with the model attributes.

###"Nesting Awards in Students"

This section builds on the "student01" application by altering routing and controller logic to create nested resources and further define the actual roles of the app's models.

To begin, open the app from the previous section (student01) in the text editor.

<sub>Alternatively, a new app can be created (i.e. "student02") that is identical to _ch09/student01_.</sub>

####"Changing the Routing"

In the text editor, open *config/routes.rb* and replace the following lines:

		resources :awards
		resources :students

With this code, which declares a nested resource relationship:

		resources :students do
			resources :awards
		end

By capturing this relationship in the app's routing, it has also creates routing helpers. For instance, the path for the **awards#new** controller action has gone from `new_award` to `new_student_award`. Running `rake routes` in the console presents all of the new routing patterns.

####"Changing the Controller"

Now that routing patterns have been created that properly relate students and awards, changes to *app/controllers/awards_controller.rb* must be made to provide the context that limits awards to a specific student.

To begin, add the following line just after the class declaration at the top of the file:

		before_action :get_student

This is a filter which references the **:get_student** method, which needs to be created at the end of the file after the **private** keyword..

		private
		
		def get_student
			@student = Student.find(params[:student_id])
		end

Now that the _@student_ instance variable is created, it can be referenced in the controller's other methods. In the **index** method, replace `@awards = Award.all` with the following line of code:

		@awards = @student.awards

In the **show** method, add the following line:

		@award = @student.awards.find(params[:id])

In the **new** method, change the `@award = Award.new` line to this:

		@award = @student.awards.build

In the **edit** method, insert the following line:

		@award = @student.awards.find(params[:id])

In the **create** method, change `@award = Award.new(award_params)` to:

		@award = @student.awards.build(award_params)

Add the following line of code to the top of the **update** method:

		@award = @student.awards.find(params[:id])

In both the **create** and **update** methods, change the *format.html* line of the **if** conditional in the *respond_to* block to this:

		format.html { redirect_to student_awards_url(@student), notice: 'Award was successfully created.' }
		# Of course, use the term "updated" for the update method notice.

Lastly, in the **destroy** method, just before `@award.destroy`, enter:

		@award = @student.awards.find(params[:id])

and change the html path in the *respond_to* block from `redirect_to awards_url` to this..

		format.html { student_awards_path(@student), notice: 'Award was successfully destroyed.' }

Save the file. However, an attempt to navigate to the awards pages as before will yield some odd results. The next section will modify the views to reflect the changes made to the controller.

####"Changing the Award Views"

Open *app/views/awards/index.html.erb* in the text editor and change the heading to reflect the student whose awards are being shown..

		<h1>Awards for <%= @student.name %></h1>

Next, the awards table must be wrapped in a conditional block. Start by adding the following **if** statement just before the `<table>` tag:

		<% if !@student.awards.empty? %>

After the closing `</table>` tag, finish the conditional statement with the following code:

		<% else %>
			<p><%= @student.given_name %> hasn't won any awards yet.</p>
		<% end %>

The `link_to` statements also need to specify the student model:

		`<td><%= link_to 'Show', [ @student, award ] %></td>`
          	`<td><%= link_to 'Edit', edit_student_award_path( @student, award ) %></td>`
          	`td><%= link_to 'Destroy', [ @student, award ], method: :delete, data: { confirm: 'Are you sure?' } %></td>`
		
		<%= link_to 'New Award', new_student_award_path(@student) %>

Also, add a link to help users navigate "back"..

		<%= link_to 'Back', @student %>

In *app/views/awards/show.html.erb*, change the `link_to` statements in similar fashion:

		<%= link_to 'Edit', edit_student_award_path(@student, @award) %>
		<%= link_to 'Back', student_awards_path(@student) %>

Both *app/views/awards/new.html.erb* and *app/views/awards/edit.html.erb* need their headings changed as follows, respectively..

		<h1>New Award for <%= @student.name%></h1>

and

		<h1>Editing Award for <%= @student.name %></h1>

Similar to the other views, the `link_to` statements at the bottom of the **new** and **edit** views need to change.

Perhaps most importantly, *app/views/_form.html.erb* needs to reference the **student** model as well. Change the `form_for` call at the first line to read as follows:

		<%= form_for([ @student, award ]) do |f| %>

Also, the field `<div` for the **student_id** attribute must also be removed. The award will only pertain to the current **student**. Remove the following block of code:

		<div class="field">
			<%= f.label :student_id %><br>
			<%= f.select :student_id, Student.all.collect {|s| [s.name, s.id]} %>
		</div>

Finally, in *app/controllers/awards_controller*, the `@award = @student.awards.find(params[:id])` lines are no longer needed in the **show**, **edit**, **update** and **destroy** methods. Delete the lines from those methods. Then scroll down to the "private" section and change the **set_award** method to specify that awards will pertain to the current **student** model...

		def set_award
			@award = @student.awards.find(params[:id])
		end

####"Connecting the Student Views"

To make it more convenient to access the student's award views, add a link to *app/views/students/show.html.erb*, just between the **Edit** and **Back** links (at the bottom of the file):

		<%= link_to 'Awards', student_awards_path(@student) %>

Also, a link should be added to *app/views/students/index.html.erb*, as a table cell - between the links to the **Edit** and **Destroy**...

		<td><%= link_to 'Awards', student_awards_path(student) %></td>

Lastly, when adding a table cell in this manner, the `colspan` attribute of the final `<th` tag (inside the `<thead></thead>` markup block) needs to be changed from "3" to "4".

###"Many-to-Many: Connecting Students to Courses"

*Many-to-many*, like *one-to-many* is a common database relationship. In this section, the **Course** model will be created. It will not be "nested" within Students, as it is essentially at an equal level from a data modeling perspective.

####"Creating Tables"

Create two new tables. The first, **Courses** will contain the actual course list and thereby need full scaffolding. In the terminal, enter:

		rails generate scaffold course name:string

Run `rake db:migrate`.

The second table will be a *join table*, which will serve to connect the Courses and Students tables. For this, generating a basic migration is sufficient and Rails 5 has a special kind of migration for just this purpose:

		rails g migration CreateJoinTableCourseStudent course student

Starting the migration name with "CreateJoinTable" will produce the appropriate migration with the *course* and *student* models connected as seen in the resulting migration. Open *db/migrate/<timestamp>_create_join_table_course_student.rb* in the text editor. Uncomment the two lines that generate the indexes (they'll be needed to allow Rails to quickly navigate through the referencing model ids), so that the resulting migration looks like this:

		class CreateJoinTableCourseStudent < ActiveRecord::Migration
			def change
				create_join_table :courses, :students do |t|
					t.index [:course_id, :student_id]
					t.index [:student_id, :course_id]
				end
			end
		end

Now run `rake db:migrate` once again to build the join table.
Note that the **change** method in a migration creates a table and indexes. These creations are inherently *reversible*, meaning that rolling back the migration will remove these objects. If the migration contained items that Active Record could not reverse, we would simply wrap the *create_...* statement with in a "reversible do" block.

####"Connecting the Models"

To declare this many-to-many relationship in the models, open *app/models/student.rb* in the text editor and add the following to the **Student** model definition, just after the `has_many :awards...` declaration:

		has_and_belongs_to_many :courses

Likewise, in *app/models/course.rb*...

		has_and_belongs_to_many :students

Now that the models are connected, add some convenience methods to the **Students** model. First, add a method that checks whether a student is enrolled in a particular course:

		def enrolled_in?(course)
			self.courses.include?(course)
		end

This will return `true` if a given course is in the student's course list. Next, create a similar method that shows which courses a student is *not* enrolled in:

		def unenrolled_courses
			Course.find(:all) - self.courses
		end

This method returns the list of courses that remains after *subtracting* those which already belong to a student. 
		

