require 'test_helper'

class GroupBeneficiariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_beneficiary = group_beneficiaries(:one)
  end

  test "should get index" do
    get group_beneficiaries_url, as: :json
    assert_response :success
  end

  test "should create group_beneficiary" do
    assert_difference('GroupBeneficiary.count') do
      post group_beneficiaries_url, params: { group_beneficiary: { beneficiary_id: @group_beneficiary.beneficiary_id, group_id: @group_beneficiary.group_id } }, as: :json
    end

    assert_response 201
  end

  test "should show group_beneficiary" do
    get group_beneficiary_url(@group_beneficiary), as: :json
    assert_response :success
  end

  test "should update group_beneficiary" do
    patch group_beneficiary_url(@group_beneficiary), params: { group_beneficiary: { beneficiary_id: @group_beneficiary.beneficiary_id, group_id: @group_beneficiary.group_id } }, as: :json
    assert_response 200
  end

  test "should destroy group_beneficiary" do
    assert_difference('GroupBeneficiary.count', -1) do
      delete group_beneficiary_url(@group_beneficiary), as: :json
    end

    assert_response 204
  end
end
