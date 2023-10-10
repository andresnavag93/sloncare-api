require 'test_helper'

class GroupAdminsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_admin = group_admins(:one)
  end

  test "should get index" do
    get group_admins_url, as: :json
    assert_response :success
  end

  test "should create group_admin" do
    assert_difference('GroupAdmin.count') do
      post group_admins_url, params: { group_admin: { admin_id: @group_admin.admin_id, group_id: @group_admin.group_id } }, as: :json
    end

    assert_response 201
  end

  test "should show group_admin" do
    get group_admin_url(@group_admin), as: :json
    assert_response :success
  end

  test "should update group_admin" do
    patch group_admin_url(@group_admin), params: { group_admin: { admin_id: @group_admin.admin_id, group_id: @group_admin.group_id } }, as: :json
    assert_response 200
  end

  test "should destroy group_admin" do
    assert_difference('GroupAdmin.count', -1) do
      delete group_admin_url(@group_admin), as: :json
    end

    assert_response 204
  end
end
