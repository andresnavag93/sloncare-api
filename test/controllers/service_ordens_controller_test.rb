require 'test_helper'

class ServiceOrdensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_orden = service_ordens(:one)
  end

  test "should get index" do
    get service_ordens_url, as: :json
    assert_response :success
  end

  test "should create service_orden" do
    assert_difference('ServiceOrden.count') do
      post service_ordens_url, params: { service_orden: { assigned_area_id: @service_orden.assigned_area_id, beneficiary_id: @service_orden.beneficiary_id, city_id: @service_orden.city_id, code_expires: @service_orden.code_expires, country_id: @service_orden.country_id, diagnosis: @service_orden.diagnosis, egress_date: @service_orden.egress_date, egress_report: @service_orden.egress_report, evolutionary_report: @service_orden.evolutionary_report, high_id_id: @service_orden.high_id_id, income_id: @service_orden.income_id, indications: @service_orden.indications, indications_comments: @service_orden.indications_comments, livelihood: @service_orden.livelihood, medical_report: @service_orden.medical_report, o_appointment_date: @service_orden.o_appointment_date, o_created_at: @service_orden.o_created_at, o_possible_appointment_date: @service_orden.o_possible_appointment_date, o_updated_at: @service_orden.o_updated_at, observations: @service_orden.observations, priority_id: @service_orden.priority_id, provider_id: @service_orden.provider_id, reason_for_admission: @service_orden.reason_for_admission, recipe: @service_orden.recipe, recipe_comments: @service_orden.recipe_comments, room_number: @service_orden.room_number, service_type_id: @service_orden.service_type_id, specialty_id: @service_orden.specialty_id, state_id: @service_orden.state_id, status_id: @service_orden.status_id, symptom: @service_orden.symptom, total: @service_orden.total, total_suggested: @service_orden.total_suggested, verification_code: @service_orden.verification_code } }, as: :json
    end

    assert_response 201
  end

  test "should show service_orden" do
    get service_orden_url(@service_orden), as: :json
    assert_response :success
  end

  test "should update service_orden" do
    patch service_orden_url(@service_orden), params: { service_orden: { assigned_area_id: @service_orden.assigned_area_id, beneficiary_id: @service_orden.beneficiary_id, city_id: @service_orden.city_id, code_expires: @service_orden.code_expires, country_id: @service_orden.country_id, diagnosis: @service_orden.diagnosis, egress_date: @service_orden.egress_date, egress_report: @service_orden.egress_report, evolutionary_report: @service_orden.evolutionary_report, high_id_id: @service_orden.high_id_id, income_id: @service_orden.income_id, indications: @service_orden.indications, indications_comments: @service_orden.indications_comments, livelihood: @service_orden.livelihood, medical_report: @service_orden.medical_report, o_appointment_date: @service_orden.o_appointment_date, o_created_at: @service_orden.o_created_at, o_possible_appointment_date: @service_orden.o_possible_appointment_date, o_updated_at: @service_orden.o_updated_at, observations: @service_orden.observations, priority_id: @service_orden.priority_id, provider_id: @service_orden.provider_id, reason_for_admission: @service_orden.reason_for_admission, recipe: @service_orden.recipe, recipe_comments: @service_orden.recipe_comments, room_number: @service_orden.room_number, service_type_id: @service_orden.service_type_id, specialty_id: @service_orden.specialty_id, state_id: @service_orden.state_id, status_id: @service_orden.status_id, symptom: @service_orden.symptom, total: @service_orden.total, total_suggested: @service_orden.total_suggested, verification_code: @service_orden.verification_code } }, as: :json
    assert_response 200
  end

  test "should destroy service_orden" do
    assert_difference('ServiceOrden.count', -1) do
      delete service_orden_url(@service_orden), as: :json
    end

    assert_response 204
  end
end
