class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :login_required
  before_filter :require_app!, :set_locale

  helper_method :current_user

  def current_app
    @app || load_app_from_session || App.root_app
  end

  def load_app_from_session
    App.find_by(id: session[:app_id])
  end

  def require_app!
    puts "do nothing"
  end


  def logged_in?
    !!current_user
  end

  def required_not_login
    if logged_in?
      flash.notice = t("notice.already_login")
      redirect_to root_path
    end
  end

  def login_required
    if !current_user
      session[:redirect_to] = request.path
      redirect_to new_session_path
    end
  end

  def current_user
    @current_user ||= login_from_session
  end

  def login_from_session
    User.find_by(id: session[:user_id])
  end

  def set_locale
    I18n.locale = session[:locale] || :en
  end

  def toggle_locale
    I18n.locale = (session[:locale] == :"zh-CN" ? :"en" : :"zh-CN")
    session[:locale] = I18n.locale
    render js: 'window.location.reload();'
  end
end
