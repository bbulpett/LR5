class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :given_name
      t.string :middle_name
      t.string :family_name
      t.date :date_of_birth
      t.decimal :grade_point_average
      t.date :start_date

      t.timestamps
    end
  end
end
