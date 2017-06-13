class AuditsController < ApplicationController
  def index
    @audits = Audit.ransack(params[:q]).result.order("id desc").page params[:page]
  end
end
