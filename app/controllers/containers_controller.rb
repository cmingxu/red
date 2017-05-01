class ContainersController < NodesController
  ACTIONS = %w(start stop kill restart pause resume remove)

  def index
    @containers = Docker::Container.all(all: true)
  end

  def show
    @container = Docker::Container.get params[:id]
  end

  ACTIONS.each do |a|
    define_method a do
      @container = Docker::Container.get params[:id]
      @container.send a
    end
  end
end
