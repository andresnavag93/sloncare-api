require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @location = locations(:one)
  end

  test "should get index" do
    get locations_url, as: :json
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post locations_url, params: { location: { location_id: @location.location_id, name: @location.name, name_en: @location.name_en, value: @location.value, value_en: @location.value_en } }, as: :json
    end

    assert_response 201
  end

  test "should show location" do
    get location_url(@location), as: :json
    assert_response :success
  end

  test "should update location" do
    patch location_url(@location), params: { location: { location_id: @location.location_id, name: @location.name, name_en: @location.name_en, value: @location.value, value_en: @location.value_en } }, as: :json
    assert_response 200
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete location_url(@location), as: :json
    end

    assert_response 204
  end
end
