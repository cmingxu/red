class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_namespace, :set_namespaces, :set_breadcrumb

  DEFAULT_DOCKER_FILE = <<EOF
  FROM ubuntu:latest
  ADD . /app
  RUN make build
  WORKDIR /app
  CMD ./start.sh
EOF

  # GET /projects
  # GET /projects.json
  def index
    @projects = @namespace.projects.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = @namespace.projects.new version_format: "version-{{timestamp}}", name: "project-name", dockerfile: DEFAULT_DOCKER_FILE
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = @namespace.projects.new(project_params)
    @project.group_id = @namespace.group_id
    @project.user_id  = @namespace.user_id

    respond_to do |format|
      if @project.save
        format.html { redirect_to @namespace, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @namespace, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_namespace
      @namespace = Namespace.find(params[:namespace_id])
    end

    def set_namespaces
      @namespaces = current_user.readable_namespaces
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:namespace_id, :dockerfile, :user_id, :group_id, :version_format, :name)
    end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "全部项目", name_en: "Namespaces", path: namespaces_path)]

    if @namespace
      @breadcrumb_list.push OpenStruct.new(name_zh_cn: @namespace.name, name_en: @namespace.name, path: namespace_path(@namespace))
    end
  end
end
