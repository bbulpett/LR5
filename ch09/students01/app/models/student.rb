class Student < ActiveRecord::Base
	# A student may have many awards
	has_many :awards

	def name
			given_name + " " + family_name
	end
end
