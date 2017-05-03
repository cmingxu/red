class VolumesController < NodesController
  def index
    @volumes = Docker::Volume.all
  end

  def show
    @volume = Docker::Volume.get params[:id]
  end
end
