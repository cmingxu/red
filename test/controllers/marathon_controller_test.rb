require 'test_helper'

class MarathonControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get marathon_index_url
    assert_response :success
  end

end
