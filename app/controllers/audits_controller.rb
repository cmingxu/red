class AuditsController < ApplicationController
  def index
    @audits = Audit.order("id desc").page params[:page]
  end
end
