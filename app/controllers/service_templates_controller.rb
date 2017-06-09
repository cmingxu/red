class ServiceTemplatesController < ApplicationController
  before_action :set_service_template, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumb

  # GET /service_templates
  # GET /service_templates.json
  def index
    @service_templates = policy_scope(ServiceTemplate).order("updated_at DESC").page params[:page]
  end

  # GET /service_templates/1
  # GET /service_templates/1.json
  def show
    authorize @service_template
  end

  # GET /service_templates/new
  def new
    @owner  = owner_from_request || current_user

    if params[:service_id]
      @service = current_user.accessible_services.find(params[:service_id])
      raw_config_params = @service.apps.reduce({}) {|p, a| p[a.id] = a.current_version.id; p}
      @service_template = @owner.service_templates.new(raw_config: @service.try(:raw_config, raw_config_params).try(:to_json) || "no content",
                                              name: @service.try(:name),
                                              desc: @service.try(:desc),
                                              readme: "Readme")
    else
      @service_template = @owner.service_templates.new(name: "New Service Template",
                                              readme: "Readme")
    end

    if !ServiceTemplatePolicy.new(current_user,  @service_template, @owner).create?
      raise Pundit::NotAuthorizedError, "not allowed to create? this #{@service_template.inspect}"
    end

  end

  # GET /service_templates/1/edit
  def edit
  end

  # POST /service_templates
  # POST /service_templates.json
  def create
    @owner  = owner_from_request || current_user
    @service_template = @owner.service_templates.new(service_template_params)


    if !ServiceTemplatePolicy.new(current_user,  @service_template, @owner).create?
      raise Pundit::NotAuthorizedError, "not allowed to create? this #{@service_template.inspect}"
    end

    respond_to do |format|
      if @service_template.save
        audit(@service_template, "create", @service_template.name)
        current_user.access_resource(@service_template, :admin)
        audit(@service_template, "grant", @service_template.name + " to user #{current_user.display} admin permission")

        if @owner.is_a?(Group)
          @owner.access_resource(@service_template, :admin)
          audit(@service_template, "grant", @owner.name + " to user #{@owenr.display} admin permission")
        end

        format.html { redirect_to service_templates_path, notice: 'Service template was successfully created.' }
        format.json { render :edit, status: :created, location: @service_template }
      else
        format.html { render :new }
        format.json { render json: @service_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_templates/1
  # PATCH/PUT /service_templates/1.json
  def update
    authorize @service_template

    respond_to do |format|
      if @service_template.update(service_template_params)
        format.html { redirect_to service_template_path(@service_template), notice: 'Service template was successfully updated.' }
        format.json { render :show, status: :ok, location: @service_template }
      else
        format.html { render :edit }
        format.json { render json: @service_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_templates/1
  # DELETE /service_templates/1.json
  def destroy
    audit(@service_template, "destroy", @service_template.name)
    authorize @service_template

    @service_template.destroy
    respond_to do |format|
      format.html { redirect_to service_templates_url, notice: 'Service template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_service_template
    @service_template = policy_scope(ServiceTemplate).find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_template_params
    params.require(:service_template).permit(:name, :icon, :group_id, :user_id, :raw_config, :desc, :readme)
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部模板", name_en: "Service Templates", path: service_templates_path)]

    if @service_template
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @service_template.name, name_en: @service_template.name, path: service_template_path(@service_template))
    end
  end
end
