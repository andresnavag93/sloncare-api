require 'test_helper'

class ImagensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @imagen = imagens(:one)
  end

  test "should get index" do
    get imagens_url, as: :json
    assert_response :success
  end

  test "should create imagen" do
    assert_difference('Imagen.count') do
      post imagens_url, params: { imagen: { image: @imagen.image, name: @imagen.name, orden_id: @imagen.orden_id } }, as: :json
    end

    assert_response 201
  end

  test "should show imagen" do
    get imagen_url(@imagen), as: :json
    assert_response :success
  end

  test "should update imagen" do
    patch imagen_url(@imagen), params: { imagen: { image: @imagen.image, name: @imagen.name, orden_id: @imagen.orden_id } }, as: :json
    assert_response 200
  end

  test "should destroy imagen" do
    assert_difference('Imagen.count', -1) do
      delete imagen_url(@imagen), as: :json
    end

    assert_response 204
  end
end
