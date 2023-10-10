require 'test_helper'

class UserAccessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_access = user_accesses(:one)
  end

  test "should get index" do
    get user_accesses_url, as: :json
    assert_response :success
  end

  test "should create user_access" do
    assert_difference('UserAccess.count') do
      post user_accesses_url, params: { user_access: { access_id: @user_access.access_id, auth_toke: @user_access.auth_toke, is_active: @user_access.is_active, user_id: @user_access.user_id, visibility: @user_access.visibility, wallet_id: @user_access.wallet_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_access" do
    get user_access_url(@user_access), as: :json
    assert_response :success
  end

  test "should update user_access" do
    patch user_access_url(@user_access), params: { user_access: { access_id: @user_access.access_id, auth_toke: @user_access.auth_toke, is_active: @user_access.is_active, user_id: @user_access.user_id, visibility: @user_access.visibility, wallet_id: @user_access.wallet_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_access" do
    assert_difference('UserAccess.count', -1) do
      delete user_access_url(@user_access), as: :json
    end

    assert_response 204
  end
end
