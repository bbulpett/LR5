class Student < ActiveRecord::Base
	# A student may have many awards
	has_many :awards
end
