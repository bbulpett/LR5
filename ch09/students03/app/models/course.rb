class Course < ActiveRecord::Base

	# a student can be on many courses, a course can have many students
	has_and_belongs_to_many :students
end
