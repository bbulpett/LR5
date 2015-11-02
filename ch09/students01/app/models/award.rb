class Award < ActiveRecord::Base
	# Every award is linked to a student, through student_id
	belongs_to :student
end
