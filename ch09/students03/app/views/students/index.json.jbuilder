json.array!(@students) do |student|
  json.extract! student, :id, :given_name, :middle_name, :family_name, :date_of_birth, :grade_point_average, :start_date
  json.url student_url(student, format: :json)
end
