class NetworksController < NodesController
  before_action :set_network, except: :index
  before_action :set_breadcrumb

  def index
    @networks = Docker::Network.all
  end

  def show
    @network = Docker::Network.get params[:id]
  end

  private

  def set_network
      @network = Docker::Network.get params[:id]
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部节点", name_en: "Nodes", path: nodes_path)]

    if @node
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @node.display, name_en: @node.display, path: node_path(@node))
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: "全部网络", name_en: "networks", path: node_networks_path(@node))
    end

    if @network
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @network.info['id'], name_en: @network.info['id'], path: node_network_path(@node, id: @network.info['id']))
    end
  end
end
