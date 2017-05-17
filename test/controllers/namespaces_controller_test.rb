require 'test_helper'

class NamespacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @namespace = namespaces(:one)
  end

  test "should get index" do
    get namespaces_url
    assert_response :success
  end

  test "should get new" do
    get new_namespace_url
    assert_response :success
  end

  test "should create namespace" do
    assert_difference('Namespace.count') do
      post namespaces_url, params: { namespace: { group_id: @namespace.group_id, name: @namespace.name, user_id: @namespace.user_id } }
    end

    assert_redirected_to namespace_url(Namespace.last)
  end

  test "should show namespace" do
    get namespace_url(@namespace)
    assert_response :success
  end

  test "should get edit" do
    get edit_namespace_url(@namespace)
    assert_response :success
  end

  test "should update namespace" do
    patch namespace_url(@namespace), params: { namespace: { group_id: @namespace.group_id, name: @namespace.name, user_id: @namespace.user_id } }
    assert_redirected_to namespace_url(@namespace)
  end

  test "should destroy namespace" do
    assert_difference('Namespace.count', -1) do
      delete namespace_url(@namespace)
    end

    assert_redirected_to namespaces_url
  end
end
