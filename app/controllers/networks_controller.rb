class NetworksController < NodesController
  before_action :set_breadcrumb
  def index
    @networks = Docker::Network.all
  end

  def show
    @network = Docker::Network.get params[:id]
  end
end
