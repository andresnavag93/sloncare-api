require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { aq_1: @user.aq_1, aq_2: @user.aq_2, birthday: @user.birthday, blood_type_id: @user.blood_type_id, businessname: @user.businessname, c1_cellphone: @user.c1_cellphone, c1_email: @user.c1_email, c1_lastname: @user.c1_lastname, c1_localphone: @user.c1_localphone, c1_name: @user.c1_name, c1_workstation: @user.c1_workstation, c2_cellphone: @user.c2_cellphone, c2_email: @user.c2_email, c2_lastname: @user.c2_lastname, c2_localphone: @user.c2_localphone, c2_name: @user.c2_name, c2_workstation: @user.c2_workstation, cellphone: @user.cellphone, city_id: @user.city_id, country_id: @user.country_id, customer_id: @user.customer_id, d_document: @user.d_document, d_email: @user.d_email, d_lastname: @user.d_lastname, d_name: @user.d_name, d_phone: @user.d_phone, d_picture: @user.d_picture, document: @user.document, email: @user.email, gender_id: @user.gender_id, lastname: @user.lastname, line_1: @user.line_1, line_2: @user.line_2, locale_id: @user.locale_id, localphone: @user.localphone, mh_permit: @user.mh_permit, ms_id: @user.ms_id, name: @user.name, nationality: @user.nationality, password: @user.password, picture: @user.picture, plan_id: @user.plan_id, race_id: @user.race_id, rif: @user.rif, rifnumber: @user.rifnumber, saving_level_id: @user.saving_level_id, savings: @user.savings, size: @user.size, size_unit_id: @user.size_unit_id, sq_1_id: @user.sq_1_id, sq_2_id: @user.sq_2_id, state_id: @user.state_id, weight: @user.weight, weight_unit_id: @user.weight_unit_id, zipcode: @user.zipcode } }, as: :json
    end

    assert_response 201
  end

  test "should show user" do
    get user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { aq_1: @user.aq_1, aq_2: @user.aq_2, birthday: @user.birthday, blood_type_id: @user.blood_type_id, businessname: @user.businessname, c1_cellphone: @user.c1_cellphone, c1_email: @user.c1_email, c1_lastname: @user.c1_lastname, c1_localphone: @user.c1_localphone, c1_name: @user.c1_name, c1_workstation: @user.c1_workstation, c2_cellphone: @user.c2_cellphone, c2_email: @user.c2_email, c2_lastname: @user.c2_lastname, c2_localphone: @user.c2_localphone, c2_name: @user.c2_name, c2_workstation: @user.c2_workstation, cellphone: @user.cellphone, city_id: @user.city_id, country_id: @user.country_id, customer_id: @user.customer_id, d_document: @user.d_document, d_email: @user.d_email, d_lastname: @user.d_lastname, d_name: @user.d_name, d_phone: @user.d_phone, d_picture: @user.d_picture, document: @user.document, email: @user.email, gender_id: @user.gender_id, lastname: @user.lastname, line_1: @user.line_1, line_2: @user.line_2, locale_id: @user.locale_id, localphone: @user.localphone, mh_permit: @user.mh_permit, ms_id: @user.ms_id, name: @user.name, nationality: @user.nationality, password: @user.password, picture: @user.picture, plan_id: @user.plan_id, race_id: @user.race_id, rif: @user.rif, rifnumber: @user.rifnumber, saving_level_id: @user.saving_level_id, savings: @user.savings, size: @user.size, size_unit_id: @user.size_unit_id, sq_1_id: @user.sq_1_id, sq_2_id: @user.sq_2_id, state_id: @user.state_id, weight: @user.weight, weight_unit_id: @user.weight_unit_id, zipcode: @user.zipcode } }, as: :json
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json
    end

    assert_response 204
  end
end
