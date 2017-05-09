class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :update, :destroy]

  def index
    @services = current_user.services.includes(:apps => [:versions]).page(params[:page])
  end

  def new
    @service = current_user.services.new
  end

  def show
  end

  def favorite
    ap params
    ap request.path
    head :ok
  end

  def create
    @service = current_user.services.new service_params
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
    params.require(:service).permit(:name)
  end
end
