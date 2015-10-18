class Person < ActiveRecord::Base
	# the name is mandatory
	validates_presence_of :name
end
