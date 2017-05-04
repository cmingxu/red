require 'test_helper'

class RabcControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rabc_index_url
    assert_response :success
  end

end
