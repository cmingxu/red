class AppsController < ApplicationController
  before_action :set_service
  before_action :set_app, except: [:index, :new, :create]

  def index
    @apps = @service.apps
  end

  def new
    @app = @service.apps.new
  end

  def show
    @app = @service.apps.find params[:id]
  end

  def create
    @app = @service.apps.new app_params
    respond_to do |format|
      if @app.save
        format.html { redirect_to services_path }
        format.json { head :ok }
      else
        format.html {render :new}
        format.json { head :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
    @app.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scaleup
  end

  def scaledown
  end

  private
  def set_service
    @service = current_user.services.find params[:service_id]
  end

  def set_app
    @app = @service.apps.find params[:id]
  end

  def app_params
    params.require(:app).permit(:name, :instances, :raw_config)
  end
end
