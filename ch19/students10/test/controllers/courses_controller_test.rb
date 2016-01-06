require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post :create, params: { course: { name: @course.name } }
    end

    assert_redirected_to course_path(Course.last)
  end

  test "should show course" do
    get :show, params: { id: @course }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @course }
    assert_response :success
  end

  test "should update course" do
    patch :update, params: { id: @course, course: { name: @course.name } }
    assert_redirected_to course_path(@course)
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete :destroy, params: { id: @course }
    end

    assert_redirected_to courses_path
  end
end
