require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  setup do
    @order = orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: { client: @order.client, close_date: @order.close_date, list_image_name: @order.list_image_name, num_comment: @order.num_comment, num_pop: @order.num_pop, num_view: @order.num_view, order_date: @order.order_date, order_message: @order.order_message, payment: @order.payment, status: @order.status }
    end

    assert_redirected_to order_path(assigns(:order))
  end

  test "should show order" do
    get :show, id: @order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @order
    assert_response :success
  end

  test "should update order" do
    patch :update, id: @order, order: { client: @order.client, close_date: @order.close_date, list_image_name: @order.list_image_name, num_comment: @order.num_comment, num_pop: @order.num_pop, num_view: @order.num_view, order_date: @order.order_date, order_message: @order.order_message, payment: @order.payment, status: @order.status }
    assert_redirected_to order_path(assigns(:order))
  end

  test "should destroy order" do
    assert_difference('Order.count', -1) do
      delete :destroy, id: @order
    end

    assert_redirected_to orders_path
  end
end
