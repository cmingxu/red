require 'test_helper'

class AuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get audits_index_url
    assert_response :success
  end

end
