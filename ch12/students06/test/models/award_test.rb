require 'test_helper'

class Award < ActiveRecord::Base
  # every award is linked to a student, through student_id
  belongs_to :student

  validates_presence_of :name, :year

  # particular award can only be given once in every year
  validates_uniqueness_of :name, :scope => :year,
    :message => "already been given for that year"

  # we started the award scheme in 1980
  validates_inclusion_of :year, :in => (1980 .. Date.today.year)
end
