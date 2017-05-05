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
        format.json { json_success(201) }
      else
        format.html { render :new }
        format.json { json_fail(422, @app.errors.full_messages.first)}
      end
    end
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
    params.require(:app).permit!

    #env_keys = params[:app][:env].try(:keys) || []
    #health_check_keys = params[:app][:health_check].try(:keys) || []
    #label_keys = params[:app][:labels].try(:keys) || []
    #gateway_keys = params[:app][:gateway].try(:keys) || {}


    #params.require(:app).permit(:cpu, :mem, :disk, :cmd, :args, :priority, :runas, :name, :instances,
                                #:constraints, :image, :network, :force_image, :privileged,
                                #:desc, :env => env_keys, :health_check => health_check_keys,
                                #:portmappings => [:hostPort, :containerPort, :name, :proto],
                                #:volumes => [:hostPath, :containerPath, :mode],
                                #:uris => [], :labels => label_keys, :gateway => gateway_keys
                               #)
  end
end
