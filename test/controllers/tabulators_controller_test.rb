require 'test_helper'

class TabulatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tabulator = tabulators(:one)
  end

  test "should get index" do
    get tabulators_url, as: :json
    assert_response :success
  end

  test "should create tabulator" do
    assert_difference('Tabulator.count') do
      post tabulators_url, params: { tabulator: { description: @tabulator.description, name: @tabulator.name, service_type_id: @tabulator.service_type_id, suggested_price: @tabulator.suggested_price } }, as: :json
    end

    assert_response 201
  end

  test "should show tabulator" do
    get tabulator_url(@tabulator), as: :json
    assert_response :success
  end

  test "should update tabulator" do
    patch tabulator_url(@tabulator), params: { tabulator: { description: @tabulator.description, name: @tabulator.name, service_type_id: @tabulator.service_type_id, suggested_price: @tabulator.suggested_price } }, as: :json
    assert_response 200
  end

  test "should destroy tabulator" do
    assert_difference('Tabulator.count', -1) do
      delete tabulator_url(@tabulator), as: :json
    end

    assert_response 204
  end
end
