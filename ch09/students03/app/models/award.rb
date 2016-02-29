class Award < ApplicationRecord

	belongs_to :student
	validates_associated :student
end
