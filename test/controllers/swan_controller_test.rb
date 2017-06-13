require 'test_helper'

class SwanControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get swan_index_url
    assert_response :success
  end

end
