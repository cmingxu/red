class VolumesController < NodesController
  before_action :set_breadcrumb

  def index
  end

  private
  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部节点", name_en: "Nodes", path: nodes_path)]

    if @node
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @node.display, name_en: @node.display, path: node_path(@node))
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: "全部存储", name_en: "Volumns", path: node_volumes_path(@node))
    end
  end
end
