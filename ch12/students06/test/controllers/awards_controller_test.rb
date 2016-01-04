require 'test_helper'

class AwardsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, student_id: students(:magnum).id
    assert_response :success
    assert_not_nil assigns(:awards)
  end

  def test_should_get_new
    get :new, student_id: students(:magnum).id
    assert_response :success
  end

  def test_should_create_award
    assert_difference('Award.count') do
      post :create, award: { year: 2008, name: 'Test award' },
student_id: students(:magnum).id
    end

    assert_redirected_to assert_redirected_to student_awards_url(students(:magnum))
  end

  def test_should_show_award
    get :show, id: awards(:skydiving).id, student_id: students(:magnum).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, id: awards(:skydiving).id, student_id: students(:magnum).id
    assert_response :success
  end

  def test_should_update_award
    put :update, id: awards(:skydiving).id, award: { }, student_id:
students(:magnum).id
    assert_redirected_to student_awards_url(students(:magnum))
  end

  def test_should_destroy_award
    assert_difference('Award.count', -1) do
      delete :destroy,  id: awards(:skydiving).id,student_id:
students(:magnum).id
    end

    assert_redirected_to student_awards_path(students(:magnum))
  end
end