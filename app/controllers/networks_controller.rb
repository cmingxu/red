class NetworksController < NodesController
  def index
    @networks = Docker::Network.all
  end

  def show
    @network = Docker::Network.get params[:id]
  end
end
