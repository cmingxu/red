class AppsController < ApplicationController
  before_action :set_service
  before_action :set_app, except: [:index, :new, :create]
  before_action :set_marathon_app, only: [:start, :scale, :restart, :stop, :rollback, :change, :backend_state]

  def index
    @apps = @service.apps
  end

  def new
    @app = @service.apps.new
  end

  def edit
    @version = @app.versions.find params[:version_id]
    @app = App.new(id: @version.app_id)
    @app.attributes = JSON.parse(@version.raw_config)
    @persisted = true
  end

  def detail
    @app = @service.apps.find params[:id]
  end

  def show
    @app = @service.apps.find params[:id]
  end

  def update
    @app.raw_config = (JSON.parse(request.raw_post)["app"] || {}).to_json
    respond_to do |format|
      if @app.update app_params
        format.html { redirect_to services_path }
        format.json { json_success(201) }
        format.js { head 201 }
      else
        format.html { render :new }
        format.json { json_fail(422, @app.errors.full_messages.first)}
        format.js { head 422 }
      end
    end
  end

  def create
    @app = @service.apps.new app_params
    @app.raw_config = (JSON.parse(request.raw_post)["app"] || {}).to_json
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

  def run
    @app.run
    @app.scale params[:start_size].to_i
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :ok }
    end
  end

  def start
    @app.start
  end

  def restart
    @app.start
  end

  def stop
    @app.stop
  end

  def suspend
    @app.stop
  end

  def change
    @version = @app.versions.find params[:version_id]
    @app.change @version
  end

  def scale
    @app.scale params[:scale_size].to_i
  end

  def backend_state
    render layout: false
  end

  private
  def set_service
    @service = current_user.readable_services.find params[:service_id]
  end

  def set_app
    @app = @service.apps.find params[:id]
  end

  def set_marathon_app
    begin
      @marathon_app = Marathon::App.get @app.marathon_app_name
    rescue Marathon::Error::NotFoundError
    rescue Marathon::Error => e
    end

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
