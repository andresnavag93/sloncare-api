require 'test_helper'

class UserSpecialtiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_specialty = user_specialties(:one)
  end

  test "should get index" do
    get user_specialties_url, as: :json
    assert_response :success
  end

  test "should create user_specialty" do
    assert_difference('UserSpecialty.count') do
      post user_specialties_url, params: { user_specialty: { specialty_id: @user_specialty.specialty_id, user_id: @user_specialty.user_id } }, as: :json
    end

    assert_response 201
  end

  test "should show user_specialty" do
    get user_specialty_url(@user_specialty), as: :json
    assert_response :success
  end

  test "should update user_specialty" do
    patch user_specialty_url(@user_specialty), params: { user_specialty: { specialty_id: @user_specialty.specialty_id, user_id: @user_specialty.user_id } }, as: :json
    assert_response 200
  end

  test "should destroy user_specialty" do
    assert_difference('UserSpecialty.count', -1) do
      delete user_specialty_url(@user_specialty), as: :json
    end

    assert_response 204
  end
end
