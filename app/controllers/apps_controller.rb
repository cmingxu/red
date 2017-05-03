class AppsController < ApplicationController
  def index
    @apps = Marathon::App.list
  end

  def show
    @app = Marathon::App.get params[:name]
  end

  def create
  end

  def update
  end

  def destroy
  end

  def scaleup
  end

  def scaledown
  end
end
