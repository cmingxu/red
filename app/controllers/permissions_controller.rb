class PermissionsController < ApplicationController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]
  before_action :set_resource
  before_action :set_accessor, only: [:create]

  # GET /permissions
  # GET /permissions.json
  def index
    @permissions = @resource.permissions
    @permission = @resource.permissions.build
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
    authorize(@resource, :update?)

    permission_hash = {resource_type: permission_params[:resource_type], resource_id: permission_params[:resource_id]}
    @permission = @accessor.permissions.find_or_initialize_by(permission_hash)

    @permission.access = @permission.access || Permission.accesses[:read]

    respond_to do |format|
      if @permission.save
        audit(@permission, "grant", " for #{@permission.resource.class.to_s} #{@permission.resource.id}" )
        format.html { redirect_to send("#{@resource_name}_path", @permission.resource), notice: 'Permission was successfully created.' }

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
      authorize @resource, :update?

      if !PermissionPolicy.new(current_user,  @permission).update?
        raise Pundit::NotAuthorizedError, "not allowed to create? this #{@service_template.inspect}"
      end

      if @permission.update(permission_params)
        audit(@permission, "grant", " #{@permission.access} for #{@permission.resource.class.to_s} #{@permission.resource.id}" )
        format.html { redirect_to send("#{@resource_name}_path", @permission.resource), notice: 'Permission was successfully updated.' }
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
    authorize @resource, :update?
    @permission.destroy
    audit(@permission, "destroy", " for #{@permission.resource.class.to_s} #{@permission.resource.id}" )
    respond_to do |format|
      format.html { redirect_to send("#{@resource_name}_path", @resource), notice: 'Permission was successfully destroyed.' }
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
    if params[:service_id]
      @resource = current_user.union_readable_services.find params[:service_id]
    elsif params[:service_template_id]
      @resource = current_user.union_readable_service_templates.find params[:service_template_id]
    elsif params[:namespace_id]
      @resource = current_user.union_readable_namespaces.find params[:namespace_id]
    else
      raise ActiveRecord::RecordNotFound
    end

    @resource_name = @resource.class.to_s.tableize.singularize.downcase
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
