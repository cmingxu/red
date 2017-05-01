require 'test_helper'

class VolumesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get volumes_index_url
    assert_response :success
  end

  test "should get show" do
    get volumes_show_url
    assert_response :success
  end

end
