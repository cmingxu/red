class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :update, :destroy, :compose_chose, :download_compose, :favorite]
  before_action :set_breadcrumb

  def index
    if params[:owner_type] == "Group"
      group = current_user.groups.find params[:owner_id]
      @services = current_user.readable_groups_services_scope([group]).order('id desc').includes(:apps => [:versions]).page(params[:page]).per(8)
    elsif params[:owner_type] == "User"
      @services = current_user.services.includes(:apps => [:versions]).order('id desc').page(params[:page]).per(8)
    else
      @services = policy_scope(Service).includes(:apps => [:versions]).order('id desc').page(params[:page]).per(8)
    end
  end

  def new
    @owner  = owner_from_request || current_user
    @service = @owner.services.new

    if !ServicePolicy.new(current_user,  @service, @owner).create?
      raise Pundit::NotAuthorizedError, "not allowed to create? this #{@service.inspect}"
    end

    if params[:service_template_id] && (@temp = ServiceTemplate.find(params[:service_template_id]))
      begin
        hash = JSON.parse @temp.raw_config
        @service.name = "Copy #{hash['name']}"
        @service.desc = hash["desc"]
        @service.compose_content = @temp.raw_config
      rescue
      end
    end
  end

  def show
    authorize @service

    if params[:app_id]
      @app = @service.apps.find params[:app_id]
    end
  end

  def compose_chose
    @apps = @service.apps.order('created_at DESC').includes(:versions)
  end

  def download_compose
    audit(@service, "download", @service.name)
    send_data @service.raw_config(params[:selected_versions].first.to_hash).to_json, :type => 'application/json; charset=UTF-8;',
      :disposition => "attachment; filename=#{@service.name.gsub(/\s+/, '-')}_compose.json"
  end

  def favorite
    authorize @service, :update?
    audit(@service, "favorite", @service.name)
    @service.toggle_favorite!
    redirect_to :back
  end

  def create
    @owner  = owner_from_request || current_user
    @service = @owner.services.new service_params

    if !ServicePolicy.new(current_user,  @service, @owner).create?
      raise Pundit::NotAuthorizedError, "not allowed to create? this #{@service.inspect}"
    end

    if @service.compose_content.present?
      begin
        @service.from_raw_config JSON.parse(@service.compose_content)
      rescue
        @service.errors.add(:compose_content, "invalid json")
      end
    end

    respond_to do |format|
      if @service.save
        audit(@service, "create", @service.name)
        current_user.access_resource(@service, :admin)
        if @owner.is_a?(Group)
          @owner.access_resource(@service, :admin)
        end

        flash.notice = t('notice.service_create_success')
        format.html { redirect_to services_path }
        format.json { head :ok }
      else
        flash.alert = t('notice.service_create_failed')
        format.html {render :new}
        format.json { head :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @service

    audit(@service, "destroy", @service.name)
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_service
    @service = policy_scope(Service).find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :desc, :compose_content)
  end

  def service_params
    params.require(:service).permit(:name, :desc, :compose_content)
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部服务", name_en: "Services", path: services_path)]

    if @service
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @service.name, name_en: @service.name, path: service_path(@service))
    end
  end
end
