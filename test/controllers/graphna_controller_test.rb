require 'test_helper'

class GraphnaControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get graphna_index_url
    assert_response :success
  end

end
