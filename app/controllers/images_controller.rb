class ImagesController < NodesController
  def index
    @images = Docker::Image.all
  end

  def show
    @image = Docker::Image.get params[:id]
  end
end
