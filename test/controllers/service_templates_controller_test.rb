require 'test_helper'

class ServiceTemplatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_template = service_templates(:one)
  end

  test "should get index" do
    get service_templates_url
    assert_response :success
  end

  test "should get new" do
    get new_service_template_url
    assert_response :success
  end

  test "should create service_template" do
    assert_difference('ServiceTemplate.count') do
      post service_templates_url, params: { service_template: { desc: @service_template.desc, group_id: @service_template.group_id, icon: @service_template.icon, name: @service_template.name, raw_config: @service_template.raw_config, readme: @service_template.readme, user_id: @service_template.user_id } }
    end

    assert_redirected_to service_template_url(ServiceTemplate.last)
  end

  test "should show service_template" do
    get service_template_url(@service_template)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_template_url(@service_template)
    assert_response :success
  end

  test "should update service_template" do
    patch service_template_url(@service_template), params: { service_template: { desc: @service_template.desc, group_id: @service_template.group_id, icon: @service_template.icon, name: @service_template.name, raw_config: @service_template.raw_config, readme: @service_template.readme, user_id: @service_template.user_id } }
    assert_redirected_to service_template_url(@service_template)
  end

  test "should destroy service_template" do
    assert_difference('ServiceTemplate.count', -1) do
      delete service_template_url(@service_template)
    end

    assert_redirected_to service_templates_url
  end
end
