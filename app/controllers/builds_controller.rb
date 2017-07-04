class BuildsController < ApplicationController
  skip_before_action :set_page_request_meta_info, :set_backend, :login_required, :set_locale
  protect_from_forgery with: :null_session
  before_action :set_project

  # POST /builds
  # POST /builds.json
  def create
    @build = @project.builds.new

    if @build.save
      if params[@project.file_var] && params[@project.file_var].is_a?(ActionDispatch::Http::UploadedFile)
        @build.update_attribute :original_filename, params[@project.file_var].original_filename
        FileUtils.mv params[@project.file_var].path, @build.build_path.join(params[@project.file_var].original_filename).to_s

        system("ls #{@build.build_path}")
      end
      @build.tag @build.build

      head :ok
    else
      render plain: @build.errors, status: :unprocessable_entity
    end
  end

  def set_project
    @project = Project.find_by token: params[:token]
    raise ActiveRecord::RecordNotFound if @project.nil?
  end
end
