class AppsController < ApplicationController
  before_action :set_service
  before_action :set_app, except: [:index, :new, :create]
  before_action :set_marathon_app, only: [:start, :scale, :restart, :stop, :rollback, :change, :backend_state]
  before_action :set_breadcrumb

  def index
    @apps = @service.apps
  end

  def new
    @app = @service.apps.new
    @app_links = @app.app_links
  end

  def edit
    @version = @app.versions.find params[:version_id]
    @app = App.new(id: @version.app_id)
    @app.attributes = JSON.parse(@version.raw_config)
    @app_links = @app.app_links
    @persisted = true
  end

  def detail
    @app = @service.apps.find params[:id]
  end

  def show
    @app = @service.apps.find params[:id]
    @app_links = @app.app_links
  end

  def update
    @app.set_raw_config(request.raw_post)
    respond_to do |format|
      if @app.update app_params
       audit(@app, "update", @app.name)
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
    @app.app_links.each do |link|
      link.service = @service
    end
    
    @app.set_raw_config(request.raw_post)
    respond_to do |format|
      if @app.save
       audit(@app, "create", @app.name)
        format.html { redirect_to services_path }
        format.json { json_success(201) }
      else
        format.html { render :new }
        format.json { json_fail(422, @app.errors.full_messages.first)}
      end
    end
  end

  def destroy
    audit(@app, "destroy", @app.name)
    @app.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def run
    audit(@app, "run", @app.name)
    @app.run
    @app.scale params[:start_size].to_i
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :ok }
    end
  end

  def start
    audit(@app, "start", @app.name)
    @app.start
  end

  def restart
    audit(@app, "restart", @app.name)
    @app.start
  end

  def stop
    audit(@app, "stop", @app.name)
    @app.stop
  end

  def suspend
    audit(@app, "suspend", @app.name)
    @app.stop
  end

  def change
    audit(@app, "change", @app.name + " to version " + params[:version_id])
    @version = @app.versions.find params[:version_id]
    @app.change @version
  end

  def scale
    audit(@app, "change", @app.name + " scale " + params[:scale_size])
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

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部服务", name_en: "Services", path: services_path)]

    if @service
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @service.name, name_en: @service.name, path: service_path(@service))
    end

    if @app
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @app.name, name_en: @app.name, path: service_app_path(@service, @app))
    end
  end

  def app_params
    converted_params = params.require(:app).permit!
    converted_params[:app_links_attributes] = converted_params.delete(:app_links)
    converted_params 



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
