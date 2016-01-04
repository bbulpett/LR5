require 'test_helper'

# Integration tests covering the manipulation of student objects

class StudentsTest < ActionDispatch::IntegrationTest

  def test_adding_a_student
    # get the new student form
    get '/students/new' # could be new_students_path

    # check there are boxes to put the name in
    # trivial in our case, but illustrates how to check output HTML
    assert_select "input[type=text][name='student[given_name]']"
    assert_select "input[type=text][name='student[family_name]']"

    assert_difference('Student.count') do
      post '/students', student: {
        given_name: "Fred",
        family_name: "Smith",
        date_of_birth: "1999-09-01",
        grade_point_average: 2.0,
        start_date: "2008-09-01"
      }
    end

    assert_redirected_to student_path(Student.last)
    follow_redirect!

    # for completeness, check it's showing some of our data
    assert_select "p", /Fred/
    assert_select "p", /2008\-09\-01/
  end

end