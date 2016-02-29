class Student < ApplicationRecord
	# A student may have many awards
	has_many :awards, dependent: :destroy

	def name
			given_name + " " + family_name
	end
end
