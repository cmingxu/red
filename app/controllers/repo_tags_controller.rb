require 'portus'

class RepoTagsController < ApplicationController
  before_action :set_namespace, :set_repository, :set_repo_tag, :set_breadcrumb
  before_action :set_registry_client

  def show
  end

  def manifest_blob_page
    @manifest = @client.manifest(@repo_tag.repository.name, @repo_tag.name)
    @blob     = @client.blobs(@repo_tag.repository.name, "sha256:" + @manifest[0])
    render layout: false
  end

  def vulnerabilities_check
    VulnerabilitiesCheckWorker.perform_in(1.seconds, @repo_tag.id)
    redirect_to namespace_repository_repo_tag_path(@namespace, @repository, @repo_tag)
  end

  def destroy
    @client.delete(@repo_tag.repository.name, @repo_tag.digest, "manifests")
    @repository.repo_tags.where(digest: @repo_tag.digest).map &:destroy
    @repository.destroy if @repository.repo_tags.length == 0
    if @repository.destroyed?
      redirect_to namespace_path(@namespace)
    else
      redirect_to namespace_repository_path(@namespace, @repository)
    end
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
    @client = Portus::RegistryClient.new(URI($base_services[:registry]).hostname, true, "admin@admin.com", "admin") 
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部镜像库", name_en: "Namespaces", path: namespaces_path)]

    if @namespace
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @namespace.name, name_en: @namespace.name, path: namespace_path(@namespace))
    end

    if @repository
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @repository.name, name_en: @repository.name, path: namespace_repository_path(@namespace, @repository))
    end

    if @repo_tag
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @repo_tag.name, name_en: @repo_tag.name, path: namespace_repository_repo_tag_path(@namespace, @repository, @repo_tag))
    end
  end
end
