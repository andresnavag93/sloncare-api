require 'test_helper'

class ProtocolWalletsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @protocol_wallet = protocol_wallets(:one)
  end

  test "should get index" do
    get protocol_wallets_url, as: :json
    assert_response :success
  end

  test "should create protocol_wallet" do
    assert_difference('ProtocolWallet.count') do
      post protocol_wallets_url, params: { protocol_wallet: { percentage: @protocol_wallet.percentage, protocol_id: @protocol_wallet.protocol_id, wallet_id: @protocol_wallet.wallet_id } }, as: :json
    end

    assert_response 201
  end

  test "should show protocol_wallet" do
    get protocol_wallet_url(@protocol_wallet), as: :json
    assert_response :success
  end

  test "should update protocol_wallet" do
    patch protocol_wallet_url(@protocol_wallet), params: { protocol_wallet: { percentage: @protocol_wallet.percentage, protocol_id: @protocol_wallet.protocol_id, wallet_id: @protocol_wallet.wallet_id } }, as: :json
    assert_response 200
  end

  test "should destroy protocol_wallet" do
    assert_difference('ProtocolWallet.count', -1) do
      delete protocol_wallet_url(@protocol_wallet), as: :json
    end

    assert_response 204
  end
end
