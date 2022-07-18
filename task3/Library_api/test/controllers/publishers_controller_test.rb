require "test_helper"

class PublishersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @publisher = publishers(:one)
  end

  test "should get index" do
    get publishers_url, as: :json
    assert_response :success
  end

  test "should create publisher" do
    assert_difference("Publisher.count") do
      post publishers_url, params: { publisher: { name: @publisher.name } }, as: :json
    end

    assert_response :created
  end

  test "should show publisher" do
    get publisher_url(@publisher), as: :json
    assert_response :success
  end

  test "should update publisher" do
    patch publisher_url(@publisher), params: { publisher: { name: @publisher.name } }, as: :json
    assert_response :success
  end

  test "should destroy publisher" do
    assert_difference("Publisher.count", -1) do
      delete publisher_url(@publisher), as: :json
    end

    assert_response :no_content
  end
end
