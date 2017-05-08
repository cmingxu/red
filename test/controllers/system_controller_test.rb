require 'test_helper'

class SystemControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get system_index_url
    assert_response :success
  end

end
