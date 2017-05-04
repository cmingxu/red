class ApplicationController < ActionController::Base
  attr_accessor :page_request_meta_info
  before_filter :set_page_request_meta_info

  protect_from_forgery with: :exception
  before_filter :login_required
  before_filter :set_locale

  helper_method :current_user, :desired_language, :page_request_meta_info


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

  def set_page_request_meta_info
    @page_request_meta_info ||= {
      active_navbar_item: determine_navbar_item,
      panel_header_and_icon: determine_panel_header_and_icon
    }
  end

  private
  def determine_navbar_item
    case controller_name.to_sym
    when :services, :app
      :services
    when :mesos
      :mesos
    when :nodes, :containers, :images, :networks, :volumes
      :nodes
    when :service_templates
      :service_templates
    when :registries
      :registries
    else
      :serivces
    end
  end

  def determine_panel_header_and_icon
    case controller_name.to_sym
    when :services, :app
      {text: :services, icon: :cogs }
    when :mesos
      {text: :mesos, icon: :cogs }
    when :nodes, :containers, :images, :networks, :volumes
      {text: :nodes, icon: :cogs }
    when :service_templates
      {text: :service_templates, icon: :cogs }
    when :registries
      {text: :registries, icon: :cogs }
    else
      {text: :services, icon: :cogs }
    end
  end

end
