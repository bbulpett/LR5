require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, params: { task: { completed: @task.completed, completed_date: @task.completed_date, description: @task.description, name: @task.name } }
    end

    assert_redirected_to task_path(Task.last)
  end

  test "should show task" do
    get :show, params: { id: @task }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @task }
    assert_response :success
  end

  test "should update task" do
    patch :update, params: { id: @task, task: { completed: @task.completed, completed_date: @task.completed_date, description: @task.description, name: @task.name } }
    assert_redirected_to task_path(@task)
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, params: { id: @task }
    end

    assert_redirected_to tasks_path
  end
end
