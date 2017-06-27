class NamespacesController < ApplicationController
  before_action :set_namespace, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumb

  # GET /namespaces
  # GET /namespaces.json
  def index
    @q = current_user.readable_namespaces.ransack(params[:q])
    @namespaces = current_user.readable_namespaces.order("id DESC").page params[:page]
  end

  # GET /namespaces/1
  # GET /namespaces/1.json
  def show
    @namespaces = current_user.readable_namespaces.order("updated_at DESC").page params[:page]
  end

  # GET /namespaces/new
  def new
    @owner  = owner_from_request || current_user
    @namespace = @owner.namespaces.new
  end

  # GET /namespaces/1/edit
  def edit
  end

  # POST /namespaces
  # POST /namespaces.json
  def create

    @owner  = owner_from_request || current_user
    @namespace = @owner.namespaces.new(namespace_params)

    respond_to do |format|
      if @namespace.save
        audit(@namespace, "create", @namespace.name)
        current_user.access_resource(@namespace, :admin)
        if @owner.is_a?(Group)
          @owner.access_resource(@namespace, :admin)
        end

        format.html { redirect_to namespaces_path, notice: 'Namespace was successfully created.' }
        format.json { render :show, status: :created, location: @namespace }
      else
        format.html { render :new }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /namespaces/1
  # PATCH/PUT /namespaces/1.json
  def update
    respond_to do |format|
      if @namespace.update(namespace_params)
        format.html { redirect_to @namespace, notice: 'Namespace was successfully updated.' }
        format.json { render :show, status: :ok, location: @namespace }
      else
        format.html { render :edit }
        format.json { render json: @namespace.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /namespaces/1
  # DELETE /namespaces/1.json
  def destroy
    audit(@service, "destroy", @service.name)
    @namespace.destroy
    respond_to do |format|
      format.html { redirect_to namespaces_url, notice: 'Namespace was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_namespace
      @namespace = Namespace.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def namespace_params
      params.require(:namespace).permit(:name, :user_id, :group_id)
    end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部项目", name_en: "Namespaces", path: namespaces_path)]

    if @namespace
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @namespace.name, name_en: @namespace.name, path: namespace_path(@namespace))
    end
  end
end
