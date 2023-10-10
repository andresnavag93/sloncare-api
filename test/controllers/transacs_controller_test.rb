require 'test_helper'

class TransacsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transac = transacs(:one)
  end

  test "should get index" do
    get transacs_url, as: :json
    assert_response :success
  end

  test "should create transac" do
    assert_difference('Transac.count') do
      post transacs_url, params: { transac: { amount: @transac.amount, description: @transac.description, income: @transac.income, outcome: @transac.outcome, wallet_id: @transac.wallet_id, wallet_rec_id: @transac.wallet_rec_id } }, as: :json
    end

    assert_response 201
  end

  test "should show transac" do
    get transac_url(@transac), as: :json
    assert_response :success
  end

  test "should update transac" do
    patch transac_url(@transac), params: { transac: { amount: @transac.amount, description: @transac.description, income: @transac.income, outcome: @transac.outcome, wallet_id: @transac.wallet_id, wallet_rec_id: @transac.wallet_rec_id } }, as: :json
    assert_response 200
  end

  test "should destroy transac" do
    assert_difference('Transac.count', -1) do
      delete transac_url(@transac), as: :json
    end

    assert_response 204
  end
end
