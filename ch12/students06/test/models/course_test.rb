require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  def test_validity
    course = Course.new
    assert !course.valid?
    course.name = "New course"
    assert course.valid?
  end
end
