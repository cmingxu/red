class ImagesController < NodesController
  before_action :set_image, except: :index
  before_action :set_breadcrumb

  def index
  end

  def show
  end

  def set_image
      @image = Docker::Image.get params[:id]
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部节点", name_en: "Nodes", path: nodes_path)]

    if @node
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @node.display, name_en: @node.display, path: node_path(@node))
    end

    if @image
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @image.name, name_en: @image.name, path: node_image_path(@node, @image))
    end
  end
end
