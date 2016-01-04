require 'test_helper'

class StudentTest < ActiveSupport::TestCase

  fixtures :students, :courses

  def test_validity
    jonathan = Student.new({:given_name => "Jonathan",
        :family_name => "Higgins"})
    assert !jonathan.valid?, "Should require date of birth, start date"
    jonathan.date_of_birth = "1989-02-03"
    jonathan.start_date = Date.today
    assert jonathan.valid?, "Failed even with all required info"
  end


  def test_name
    jonathan = Student.new({:given_name => "Jonathan",
        :family_name => "Higgins"})
    assert_equal jonathan.name, "Jonathan Higgins", "name method screwed up"
  end

  def test_enrolled_in
    tc = students(:tc)
    assert tc.enrolled_in?(courses(:aviation)), "TC not enrolled in surveillance?"
    assert !tc.enrolled_in?(courses(:security)), "TC should stay out of security"
  end

  def test_unenrolled_courses
    magnum = students(:magnum)
    rick = students(:rick)
    assert_equal [courses(:aviation)], magnum.unenrolled_courses
    assert_equal [courses(:aviation)], rick.unenrolled_courses
    jonathan = Student.new({:given_name => "Jonathan", :family_name => "Higgins"})
    assert_equal Course.all, jonathan.unenrolled_courses
  end
end
