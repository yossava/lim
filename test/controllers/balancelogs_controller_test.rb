require 'test_helper'

class BalancelogsControllerTest < ActionController::TestCase
  setup do
    @balancelog = balancelogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:balancelogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create balancelog" do
    assert_difference('Balancelog.count') do
      post :create, balancelog: { cart_id: @balancelog.cart_id, keterangan: @balancelog.keterangan, nominal: @balancelog.nominal, saldo: @balancelog.saldo }
    end

    assert_redirected_to balancelog_path(assigns(:balancelog))
  end

  test "should show balancelog" do
    get :show, id: @balancelog
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @balancelog
    assert_response :success
  end

  test "should update balancelog" do
    patch :update, id: @balancelog, balancelog: { cart_id: @balancelog.cart_id, keterangan: @balancelog.keterangan, nominal: @balancelog.nominal, saldo: @balancelog.saldo }
    assert_redirected_to balancelog_path(assigns(:balancelog))
  end

  test "should destroy balancelog" do
    assert_difference('Balancelog.count', -1) do
      delete :destroy, id: @balancelog
    end

    assert_redirected_to balancelogs_path
  end
end
