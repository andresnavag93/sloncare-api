require 'test_helper'

class UserTabsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_tab = user_tabs(:one)
  end

  test "should get index" do
    get user_tabs_url, as: :json
    assert_response :success
  end

  test "should create user_tab" do
    assert_difference('UserTab.count') do
      post user_tabs_url, params: { user_tab: { tabulator_id: @user_tab.tabulator_id, user_specialties_id: @user_tab.user_specialties_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_tab" do
    get user_tab_url(@user_tab), as: :json
    assert_response :success
  end

  test "should update user_tab" do
    patch user_tab_url(@user_tab), params: { user_tab: { tabulator_id: @user_tab.tabulator_id, user_specialties_id: @user_tab.user_specialties_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_tab" do
    assert_difference('UserTab.count', -1) do
      delete user_tab_url(@user_tab), as: :json
    end

    assert_response 204
  end
end
