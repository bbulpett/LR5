class Student < ApplicationRecord

	has_many :awards, dependent: :destroy
	has_and_belongs_to_many :courses

	def name
		given_name + " " + family_name
	end

	def enrolled_in?(course)
			self.courses.include?(course)
	end

	def unenrolled_courses
			Course.all - self.courses
	end
end
