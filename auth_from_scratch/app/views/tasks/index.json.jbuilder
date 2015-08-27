json.array!(@tasks) do |task|
  json.extract! task, :id, :name, :description, :completed, :completed_date
  json.url task_url(task, format: :json)
end
