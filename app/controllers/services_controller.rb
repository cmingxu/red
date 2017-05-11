class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :update, :destroy, :compose_chose, :download_compose, :favorite]

  def index
    @services = current_user.services.includes(:apps => [:versions]).page(params[:page])
  end

  def new
    @service = current_user.services.new
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
  end

  def compose_chose
    @apps = @service.apps.order('created_at DESC').includes(:versions)
  end

  def download_compose
    send_data @service.raw_config(params[:selected_versions].first.to_hash).to_json, :type => 'application/json; charset=UTF-8;',
      :disposition => "attachment; filename=#{@service.name.gsub(/\s+/, '-')}_compose.json"
  end

  def favorite
    @service.toggle_favorite!
    redirect_to :back
  end

  def create
    @service = current_user.services.new service_params
    if @service.compose_content.present?
      begin
        @service.from_raw_config JSON.parse(@service.compose_content)
      rescue
        @service.errors.on(:compose_content, "invalid json")
      end
    end

    respond_to do |format|
      if @service.save
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
    @service.destroy
    respond_to do |format|
      format.html { redirect_to service_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :desc, :compose_content)
  end

  def service_params
    params.require(:service).permit(:name, :desc, :compose_content)
  end
end
