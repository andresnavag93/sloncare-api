require 'test_helper'

class DoctorClinicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doctor_clinic = doctor_clinics(:one)
  end

  test "should get index" do
    get doctor_clinics_url, as: :json
    assert_response :success
  end

  test "should create doctor_clinic" do
    assert_difference('DoctorClinic.count') do
      post doctor_clinics_url, params: { doctor_clinic: { clinic_id: @doctor_clinic.clinic_id, doctor_id: @doctor_clinic.doctor_id } }, as: :json
    end

    assert_response 201
  end

  test "should show doctor_clinic" do
    get doctor_clinic_url(@doctor_clinic), as: :json
    assert_response :success
  end

  test "should update doctor_clinic" do
    patch doctor_clinic_url(@doctor_clinic), params: { doctor_clinic: { clinic_id: @doctor_clinic.clinic_id, doctor_id: @doctor_clinic.doctor_id } }, as: :json
    assert_response 200
  end

  test "should destroy doctor_clinic" do
    assert_difference('DoctorClinic.count', -1) do
      delete doctor_clinic_url(@doctor_clinic), as: :json
    end

    assert_response 204
  end
end
