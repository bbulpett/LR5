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

To declare this many-to-many relationship in the models, open *app/models/student.rb* in the text editor and add the following to the **Student** model definition:

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
		
