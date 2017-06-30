require 'test_helper'

class BuildsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @build = builds(:one)
  end

  test "should get index" do
    get builds_url
    assert_response :success
  end

  test "should get new" do
    get new_build_url
    assert_response :success
  end

  test "should create build" do
    assert_difference('Build.count') do
      post builds_url, params: { build: { build_status: @build.build_status, project_id: @build.project_id, serial_num: @build.serial_num, version_name: @build.version_name } }
    end

    assert_redirected_to build_url(Build.last)
  end

  test "should show build" do
    get build_url(@build)
    assert_response :success
  end

  test "should get edit" do
    get edit_build_url(@build)
    assert_response :success
  end

  test "should update build" do
    patch build_url(@build), params: { build: { build_status: @build.build_status, project_id: @build.project_id, serial_num: @build.serial_num, version_name: @build.version_name } }
    assert_redirected_to build_url(@build)
  end

  test "should destroy build" do
    assert_difference('Build.count', -1) do
      delete build_url(@build)
    end

    assert_redirected_to builds_url
  end
end
