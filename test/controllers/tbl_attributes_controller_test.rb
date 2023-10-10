require 'test_helper'

class TblAttributesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tbl_attribute = tbl_attributes(:one)
  end

  test "should get index" do
    get tbl_attributes_url, as: :json
    assert_response :success
  end

  test "should create tbl_attribute" do
    assert_difference('TblAttribute.count') do
      post tbl_attributes_url, params: { tbl_attribute: { amount: @tbl_attribute.amount, name: @tbl_attribute.name, name_en: @tbl_attribute.name_en, tbl_attribute_id: @tbl_attribute.tbl_attribute_id, value: @tbl_attribute.value, value_en: @tbl_attribute.value_en } }, as: :json
    end

    assert_response 201
  end

  test "should show tbl_attribute" do
    get tbl_attribute_url(@tbl_attribute), as: :json
    assert_response :success
  end

  test "should update tbl_attribute" do
    patch tbl_attribute_url(@tbl_attribute), params: { tbl_attribute: { amount: @tbl_attribute.amount, name: @tbl_attribute.name, name_en: @tbl_attribute.name_en, tbl_attribute_id: @tbl_attribute.tbl_attribute_id, value: @tbl_attribute.value, value_en: @tbl_attribute.value_en } }, as: :json
    assert_response 200
  end

  test "should destroy tbl_attribute" do
    assert_difference('TblAttribute.count', -1) do
      delete tbl_attribute_url(@tbl_attribute), as: :json
    end

    assert_response 204
  end
end
