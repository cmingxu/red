class RepoTagsController < ApplicationController
  before_action :set_namespace, :set_repository, :set_repo_tag, :set_breadcrumb
  before_action :set_registry_client

  def show
    @manifest = @client.manifest(@repo_tag.repository.name, @repo_tag.name)
  end

  private

  def set_namespace
    @namespace = Namespace.find(params[:namespace_id])
    @namespaces = Namespace.all
  end

  def set_repository
    @repository = @namespace.repositories.find params[:repository_id]
  end

  def set_repo_tag
    @repo_tag = @repository.repo_tags.find params[:id]
  end

  def set_registry_client
    @client = Portus::RegistryClient.new($base_services[:registry], true, "admin@admin.com", "admin") 
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部镜像库", name_en: "Namespaces", path: namespaces_path)]

    if @namespace
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @namespace.name, name_en: @namespace.name, path: namespace_path(@namespace))
    end

    if @repository
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @repository.name, name_en: @repository.name, path: namespace_repository_path(@namespace, @repository))
    end
  end
end
