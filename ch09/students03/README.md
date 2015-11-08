#LR5

##Chapter 9
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

Now that the models are connected, add some convenience methods to the **Students** model. First, add a method (after the **name** method) that checks whether a student is enrolled in a particular course:

		def enrolled_in?(course)
			self.courses.include?(course)
		end

This will return `true` if a given course is in the student's course list. Next, create a similar method that shows which courses a student is *not* enrolled in:

		def unenrolled_courses
			Course.find(:all) - self.courses
		end

This method returns the list of courses that remains after *subtracting* those which already belong to a student. 
		
####"Adding to the Controllers"

The next step is to supplement the existing RESTful interfaces in the controllers by adding methods that will add to their functionality. In *app/controllers/students_controller.rb*, add a method to determine which courses belong to the current student. The **@student** instance variable has already been defined in the private `set_student` method. Just after this method, add the following code:

		def courses
			@courses = @student.courses
		end

The `course_add` method, as its name describes, will add a course for the student. Add it just after the `destroy` method...

		def course_add
			@course = Course.find(params[:course])

			unless @student.enrolled_in?(@course)
				@student.courses << @course
				flash[:notice] = 'Student was successfully enrolled'
			else
				flash[:error] = 'Student was already enrolled'
			end
			redirect_to :action => :courses, id => @student
		end

Next, the `course_remove` method will be used to "unenroll" a student from a course:

		def course_remove
			@course_ids = params[:courses]
			
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
			redirect_to :action => :courses, :id => @student
		end

####"Adding Routing"

todo

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
