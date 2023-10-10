require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
  end

  test "should get index" do
    get groups_url, as: :json
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post groups_url, params: { group: { a_count: @group.a_count, b_count: @group.b_count, c1_cellphone: @group.c1_cellphone, c1_email: @group.c1_email, c1_lastname: @group.c1_lastname, c1_localphone: @group.c1_localphone, c1_name: @group.c1_name, c1_workstation: @group.c1_workstation, c2_cellphone: @group.c2_cellphone, c2_email: @group.c2_email, c2_lastname: @group.c2_lastname, c2_localphone: @group.c2_localphone, c2_name: @group.c2_name, c2_workstation: @group.c2_workstation, c_cellphone: @group.c_cellphone, c_document: @group.c_document, c_email: @group.c_email, c_lastname: @group.c_lastname, c_localphone: @group.c_localphone, c_name: @group.c_name, c_rif: @group.c_rif, c_rifnumber: @group.c_rifnumber, city_id: @group.city_id, country_id: @group.country_id, customer_id: @group.customer_id, is_active: @group.is_active, line_1: @group.line_1, line_2: @group.line_2, locale_id: @group.locale_id, plan_id: @group.plan_id, saving_level_id: @group.saving_level_id, savings: @group.savings, state_id: @group.state_id, wallet_id: @group.wallet_id, zipcode: @group.zipcode } }, as: :json
    end

    assert_response 201
  end

  test "should show group" do
    get group_url(@group), as: :json
    assert_response :success
  end

  test "should update group" do
    patch group_url(@group), params: { group: { a_count: @group.a_count, b_count: @group.b_count, c1_cellphone: @group.c1_cellphone, c1_email: @group.c1_email, c1_lastname: @group.c1_lastname, c1_localphone: @group.c1_localphone, c1_name: @group.c1_name, c1_workstation: @group.c1_workstation, c2_cellphone: @group.c2_cellphone, c2_email: @group.c2_email, c2_lastname: @group.c2_lastname, c2_localphone: @group.c2_localphone, c2_name: @group.c2_name, c2_workstation: @group.c2_workstation, c_cellphone: @group.c_cellphone, c_document: @group.c_document, c_email: @group.c_email, c_lastname: @group.c_lastname, c_localphone: @group.c_localphone, c_name: @group.c_name, c_rif: @group.c_rif, c_rifnumber: @group.c_rifnumber, city_id: @group.city_id, country_id: @group.country_id, customer_id: @group.customer_id, is_active: @group.is_active, line_1: @group.line_1, line_2: @group.line_2, locale_id: @group.locale_id, plan_id: @group.plan_id, saving_level_id: @group.saving_level_id, savings: @group.savings, state_id: @group.state_id, wallet_id: @group.wallet_id, zipcode: @group.zipcode } }, as: :json
    assert_response 200
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete group_url(@group), as: :json
    end

    assert_response 204
  end
end
