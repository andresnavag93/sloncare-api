require 'test_helper'

class OrdenRecordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @orden_record = orden_records(:one)
  end

  test "should get index" do
    get orden_records_url, as: :json
    assert_response :success
  end

  test "should create orden_record" do
    assert_difference('OrdenRecord.count') do
      post orden_records_url, params: { orden_record: { description: @orden_record.description, price: @orden_record.price, record_id: @orden_record.record_id, service_orden_id: @orden_record.service_orden_id, title: @orden_record.title } }, as: :json
    end

    assert_response 201
  end

  test "should show orden_record" do
    get orden_record_url(@orden_record), as: :json
    assert_response :success
  end

  test "should update orden_record" do
    patch orden_record_url(@orden_record), params: { orden_record: { description: @orden_record.description, price: @orden_record.price, record_id: @orden_record.record_id, service_orden_id: @orden_record.service_orden_id, title: @orden_record.title } }, as: :json
    assert_response 200
  end

  test "should destroy orden_record" do
    assert_difference('OrdenRecord.count', -1) do
      delete orden_record_url(@orden_record), as: :json
    end

    assert_response 204
  end
end
