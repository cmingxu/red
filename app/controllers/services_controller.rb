class ServicesController < ApplicationController
  def index
    @services = Service.page params[:page]
  end

  def show
  end
end
