require 'test_helper'

class RepoTagsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get repo_tags_show_url
    assert_response :success
  end

end
