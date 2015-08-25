require 'test_helper'

class PeopleControllerTest < ActionController::TestCase
  setup do
    @person = people(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post :create, params: { person: { name: @person.name } }
    end

    assert_redirected_to person_path(Person.last)
  end

  test "should show person" do
    get :show, params: { id: @person }
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: { id: @person }
    assert_response :success
  end

  test "should update person" do
    patch :update, params: { id: @person, person: { name: @person.name } }
    assert_redirected_to person_path(@person)
  end

  test "should destroy person" do
    assert_difference('Person.count', -1) do
      delete :destroy, params: { id: @person }
    end

    assert_redirected_to people_path
  end
end
