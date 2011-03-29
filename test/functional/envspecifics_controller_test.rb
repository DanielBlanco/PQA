require 'test_helper'

class EnvspecificsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:envspecifics)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create envspecific" do
    assert_difference('Envspecific.count') do
      post :create, :envspecific => { }
    end

    assert_redirected_to envspecific_path(assigns(:envspecific))
  end

  test "should show envspecific" do
    get :show, :id => envspecifics(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => envspecifics(:one).to_param
    assert_response :success
  end

  test "should update envspecific" do
    put :update, :id => envspecifics(:one).to_param, :envspecific => { }
    assert_redirected_to envspecific_path(assigns(:envspecific))
  end

  test "should destroy envspecific" do
    assert_difference('Envspecific.count', -1) do
      delete :destroy, :id => envspecifics(:one).to_param
    end

    assert_redirected_to envspecifics_path
  end
end
