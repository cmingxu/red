require 'test_helper'

class PodsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pods_index_url
    assert_response :success
  end

  test "should get new" do
    get pods_new_url
    assert_response :success
  end

end
