require 'test_helper'

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get owner_search" do
    get search_owner_search_url
    assert_response :success
  end

end
