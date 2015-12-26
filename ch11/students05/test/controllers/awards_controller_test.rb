require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  setup do
    @award = awards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create award" do
    assert_difference('Award.count') do
      post :create, params: { award: { name: @award.name, student_id: @award.student_id, year: @award.year } }
    end

    assert_redirected_to award_path(Award.last)
  end

  test "should show award" do
    get :show, params: { id: @award }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @award }
    assert_response :success
  end

  test "should update award" do
    patch :update, params: { id: @award, award: { name: @award.name, student_id: @award.student_id, year: @award.year } }
    assert_redirected_to award_path(@award)
  end

  test "should destroy award" do
    assert_difference('Award.count', -1) do
      delete :destroy, params: { id: @award }
    end

    assert_redirected_to awards_path
  end
end
