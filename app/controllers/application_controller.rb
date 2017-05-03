class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :login_required
  before_filter :set_locale

  helper_method :current_user, :desired_language


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

  def desired_language
    (session[:locale] || "en").to_sym == :en ? "中文" : "English"
  end

  def set_locale
    I18n.locale = session[:locale] || :en
  end

  def toggle_locale
    I18n.locale = (session[:locale] == "zh-CN" ? "en" : "zh-CN")
    session[:locale] = I18n.locale
    render js: 'window.location.reload();'
  end
end
