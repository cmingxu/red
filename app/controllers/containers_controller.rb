class ContainersController < NodesController
  ACTIONS = %w(start stop kill restart pause resume remove)
  before_action :set_container, except: :index
  before_action :set_breadcrumb

  def index
    @containers = Docker::Container.all(all: true)
  end

  def show
  end

  ACTIONS.each do |a|
    define_method a do
      @container.send a
    end
  end

  def stats
  end

  def stats_json
    render json: @container.stats
  end

  def logs
  end

  def console
  end

  private

  def set_container
      @container = Docker::Container.get params[:id]
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部节点", name_en: "Nodes", path: nodes_path)]

    if @node
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @node.display, name_en: @node.display, path: node_path(@node))
    end


    @breadcrumb_list.push OpenStruct.new(name_zh_cn: "全部容器", name_en: "Containers", path: node_containers_path(@node))

    if @container
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @container.info["Name"], name_en: @container.info["Name"], path: node_container_path(@node, id: @container.info["id"]))
    end
  end
end
