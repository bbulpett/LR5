class CreateCoursesStudents < ActiveRecord::Migration
  def change
    create_table :courses_students do |t|
			t.integer :course_id, :null => false
			t.integer :student_id, :null => false
    end
  end
end
