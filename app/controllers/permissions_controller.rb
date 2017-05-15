class PermissionsController < ApplicationController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_resource
  before_action :set_accessor, only: [:create]

  # GET /permissions
  # GET /permissions.json
  def index
    @services = current_user.readable_services
    @resource = @service = current_user.readable_services.find params[:service_id]
    @permissions = @service.permissions
    @permission = @service.permissions.build
  end

  # GET /permissions/1
  # GET /permissions/1.json
  def show
  end

  # GET /permissions/new
  def new
    @permission = Permission.new
  end

  # GET /permissions/1/edit
  def edit
  end

  # POST /permissions
  # POST /permissions.json
  def create
    @permission = @accessor.permissions.new(permission_params)

    respond_to do |format|
      if @permission.save
        @accessor.access_resource(@permission.resource, :read)
        format.html { redirect_to service_permissions_path(@permission.resource), notice: 'Permission was successfully created.' }
        format.json { render :show, status: :created, location: @permission }
      else
        format.html { render :new }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /permissions/1
  # PATCH/PUT /permissions/1.json
  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to @permission, notice: 'Permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @permission }
      else
        format.html { render :edit }
        format.json { render json: @permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /permissions/1
  # DELETE /permissions/1.json
  def destroy
    @permission.destroy
    respond_to do |format|
      format.html { redirect_to service_permissions_path(@service), notice: 'Permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_accessor
      accessor_type = (params[:accessor_type] || permission_params[:accessor_type]).classify.constantize
      accessor_id = (params[:accessor_id] || permission_params[:accessor_id])
      @accessor = accessor_type.find(accessor_id)
    end

    def set_resource
      @service = current_user.readable_services.find params[:service_id]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_permission
      @permission = Permission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def permission_params
      params.require(:permission).permit(:resource_type, :resource_id, :access, :accessor_type, :accessor_id)
    end
end
