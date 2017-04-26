class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :require_app!

  def current_app
    @app || load_app_from_session || App.root_app
  end

  def load_app_from_session
    App.find_by(id: session[:app_id])
  end

  def require_app!
    puts "do nothing"
  end
end
