require 'test_helper'

class SloncodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sloncode = sloncodes(:one)
  end

  test "should get index" do
    get sloncodes_url, as: :json
    assert_response :success
  end

  test "should create sloncode" do
    assert_difference('Sloncode.count') do
      post sloncodes_url, params: { sloncode: { code: @sloncode.code, encrypt_id: @sloncode.encrypt_id, p_reference: @sloncode.p_reference, payment_id: @sloncode.payment_id, price: @sloncode.price, transac_id: @sloncode.transac_id } }, as: :json
    end

    assert_response 201
  end

  test "should show sloncode" do
    get sloncode_url(@sloncode), as: :json
    assert_response :success
  end

  test "should update sloncode" do
    patch sloncode_url(@sloncode), params: { sloncode: { code: @sloncode.code, encrypt_id: @sloncode.encrypt_id, p_reference: @sloncode.p_reference, payment_id: @sloncode.payment_id, price: @sloncode.price, transac_id: @sloncode.transac_id } }, as: :json
    assert_response 200
  end

  test "should destroy sloncode" do
    assert_difference('Sloncode.count', -1) do
      delete sloncode_url(@sloncode), as: :json
    end

    assert_response 204
  end
end
