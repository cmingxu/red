class NodesController < ApplicationController
  before_action :set_node
  before_action :load_nodes
  before_action :set_breadcrumb

  # GET /nodes
  # GET /nodes.json
  def index
    @state = mesos_state
    @nodes = Node.page params[:page]
    @containers = Docker::Container.all(all: true)
    @volumes = Docker::Volume.all(all: true)
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
    @containers = Docker::Container.all(all: true)
    @volumes = Docker::Volume.all(all: true)
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # GET /nodes/1/edit
  def edit
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(node_params)

    respond_to do |format|
      if @node.save
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render :show, status: :created, location: @node }
      else
        format.html { render :new }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /nodes/1
  # PATCH/PUT /nodes/1.json
  def update
    respond_to do |format|
      if @node.update(node_params)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { render :show, status: :ok, location: @node }
      else
        format.html { render :edit }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node.destroy
    respond_to do |format|
      format.html { redirect_to nodes_url, notice: 'Node was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_node
      @node = Node.find(params[:node_id] || params[:id]) if params[:id] or params[:node_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def node_params
      params.require(:node).permit(:hostname, :state)
    end

    def load_nodes
      @nodes = Node.all
    end

  def mesos_state
    Rails.cache.fetch("mesos-object", expires_in: 60.second) do
      Mesos.new(leader: "http://114.55.130.152:5050").state
    end
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部节点", name_en: "Nodes", path: nodes_path)]

    if @node
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @node.id, name_en: @node.id, path: service_path(@node))
    end

    if @app
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @app.id, name_en: @app.id, path: service_app_path(@service, @app))
    end
  end
end
