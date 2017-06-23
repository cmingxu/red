class AuditsController < ApplicationController
  before_action :set_breadcrumb

  def index
    @audits = Audit.ransack(params[:q]).result.order("id desc").page params[:page]
  end

  def set_breadcrumb
    @breadcrumb_list = [OpenStruct.new(name_zh_cn: "审计", name_en: "Audits", path: audits_path)]
  end
end
