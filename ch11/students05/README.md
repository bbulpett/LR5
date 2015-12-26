#LR5

##Chapter 9
###"Many-to-Many: Connecting Students to Courses"

*Many-to-many*, like *one-to-many* is a common database relationship. In this section, the **Course** model will be created. It will not be "nested" within Students, as it is essentially at an equal level from a data modeling perspective.

This section builds on the "student02" application by altering routing and controller logic to create nested resources and further define the actual roles of the app's models.

To begin, open the app from the previous section (student02) in the text editor.

<sub>Alternatively, a new app can be created (i.e. "student03") that is identical to _ch09/student02_.</sub>

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

Now that the models are connected, add some convenience methods to the **Students** model. First, add a method (after the **name** method) that checks whether a student is enrolled in a particular course:

		def enrolled_in?(course)
			self.courses.include?(course)
		end

This will return `true` if a given course is in the student's course list. Next, create a similar method that shows which courses a student is *not* enrolled in:

		def unenrolled_courses
			Course.all - self.courses
		end

This method returns the list of courses that remains after *subtracting* those which already belong to a student. 
		
####"Adding to the Controllers"

The next step is to supplement the existing RESTful interfaces in the controllers by adding methods that will add to their functionality. 

*app/controllers/courses_controller.rb* needs just one extra method, **roll**, which when provided the appropriate view (*app/views/courses/roll.html.erb*) will list the students enrolled in the course. Add the method to the *courses_controller*:

		def roll
			@course = Course.find(params[:id])
		end

In *app/controllers/students_controller.rb*, add a method to determine which courses belong to the current student. Just after the `destroy` method, add the following code:

		def courses
			@student = Student.find(params[:id])
			@courses = @student.courses
		end

The `course_add` method, as its name describes, will add a course for the student. Add it just after the `courses` method...

		def course_add
			@student = Student.find(params[:id])
			@course = Course.find(params[:course])

			unless @student.enrolled_in?(@course)
				@student.courses << @course
				flash[:notice] = 'Student was successfully enrolled'
			else
				flash[:error] = 'Student was already enrolled'
			end
			redirect_to action: "courses", id: @student
		end

Next, the `course_remove` method will be used to "unenroll" a student from a course:

		def course_remove
			@student = Student.find(params[:id])
			course_ids = params[:courses]
			
			unless course_ids.blank?
				course_ids.each do |course_id|
					course = Course.find(course_id)
					if @student.enrolled_in?(course)
						logger.info "Removeing student from course #{course.id}"
						@student.courses.delete(course)
						flash[:notice] = 'Course was successfully deleted'
					end
				end
			end
			redirect_to action: "courses", id: @student
		end

####"Adding Routing"

In the text editor, open *config/routes.rb* and add the routing which will allow rails to find the new course methods. The updated *resources* block for **students** will look like this:

		resources :students do
			resources :awards

			member do
				get :courses
				post :course_add
				post :course_remove
			end
		end

In addition, **courses** needs routing to connect to the view for the added *roll* method. The syntax for this route is as follows:

		resources :courses do
			member do
				get :roll
			end
		end

####"Supporting the Relationship Through Views"
#####"Establishing navigation"

To allow users to easily navigate between course and student views, create a navigation *partial* to be used across those different views. Within *app/views*, create a new subdirectory called *application*, which will contain a file called *_navigation.html.erb*. A simple partial with navigation links, *app/views/application/_navigation.html.erb* should look like this:

		<p>
			<%= link_to "Students", students_url %> |
			<%= link_to "Courses", courses_url %>
		</p>
	
		<hr />

To render the partial across all views, add the following statement to *app/views/layouts/application.html.erb*:

		<body>
	
		<%= render 'navigation' %>

		<%= yield %>

#####"Showing counts"

Just as *app/views/students/index.html.erb* displays a count for the student's awards, a count for their courses can also be listed. In the view's `<thead>` block, add the following heading just before `<th>Awards</th>`:

		<th>Courses</th>

Now add the following table cell just before the `student.awards.count` cell:

		<td><%= student.courses.count %></td>

Similarly, in *app/views/courses/index.html.erb*, add the following table heading just after the "Name" heading:

		<th>Enrolled</th>

And just after the table cell for `course.name`, add the following..

		<td><%= course.students.count %></td>

#####"Enrolling students in courses"

In *app/views/students/show.html.erb*, just before the `<h3>Awards</h3>` statement, add the following block of code that will display the student's courses (if they have any):

		<p>
			<strong>Courses:</strong>
			<% if !@student.courses.empty? %>
				<%= @student.courses.collect {|c| link_to(c.name, c)}.join(", ").html_safe %>
			<% else %>
				Not enrolled in any courses yet.
			<% end %>
		</p>

Next, add another `link_to` statement to the others at the bottom of the file:

		<%= link_to 'Courses', courses_student_path(@student) %>

Before the above "Courses" link can be used, the view must be created. Create the file *app/views/students/courses.html.erb*, like this:

		<h1><%= @student.name %>'s courses</h1>

		<% if @courses.length > 0 %>
			<%= form_tag(course_remove_student_path(@student)) do %>
		<table>
		  <thead>
			<tr>
			<th>Course</th>
			<th>Remove?</th>
			</tr>
		  </thead>

		  <tbody>
			<% for course in @courses do %>
			<tr>
			<td><%= course.name %></td>
			<td><%= check_box_tag "courses[]", course.id %></td>
			</tr>
			<% end %>
		  </tbody>
		</table>

		<br />
			<%= submit_tag 'Remove checked courses' %>
		<% end %>
		<% else %>
			<p>Not enrolled in any courses yet.</p>
		<% end %>

		<h2>Enroll in new course</h2>
		<% if @student.courses.count < Course.count then %>
			<%= form_tag(course_add_student_path(@student)) do %>
			<%= select_tag(:course, options_from_collection_for_select(@student.unenrolled_courses, :id, :name)) %>
			<%= submit_tag 'Enroll' %>
			<% end %>
		<% else %>
			<p><%= @student.name %> is enrolled in every course.</p>
		<% end %>
		<p><%=link_to "Back", @student %></p>

In the "show" view for **courses**, *app/views/courses/show.html.erb*, place an additional `link_to` statement between the "Edit" and "Back" links:

		<%= link_to 'Roll', roll_course_path(@course) %>

This uses a route which was created in the above section, "Adding Routing", that corresponds with the **roll** method added to *courses_controller.rb*. Add a new file called *app/views/courses/roll.html.erb* that contains the following code:

		<h1>Roll for <%= @course.name %></h1>

		<% if @course.students.count > 0 %>
			<table>
				<thead>
					<tr>
						<th>Student</th>
						<th>GPA</th>
					</tr>
				</thead>
				<tbody>
					<% for student in @course.students do %>
					<tr>
						<td><%= link_to student.name, student %></td>
						<td><%= student.grade_point_average %></td>
					</tr>
					<% end %>
				</tbody>
			</table>
		<% else %>
			<p>No students are enrolled.</p>
		<% end %>

		<p><%= link_to "Back", @course %></p>

Save the file and navigate to *localhost:3000/courses* in the browser. Create a new course, add some students, and visit the "roll" page to view the results.

***
<sup>Tested and reconciled with changes made to book text</sup>
