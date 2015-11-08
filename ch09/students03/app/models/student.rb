class Student < ActiveRecord::Base
	# A student may have many awards
	has_many :awards, dependent: :destroy

	# a student can be on many courses, a course can have many students
	has_and_belongs_to_many :courses

	def name
			given_name + " " + family_name
	end

	# check if the student is enrolled in a particular course
	def enrolled_in?(course)
		self.courses.include?(course)
	end

	# list the courses that student is NOT enrolled in
	def unenrolled_courses
		Course.find(:all) - self.courses
	end

end
