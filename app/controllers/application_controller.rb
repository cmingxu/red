class ApplicationController < ActionController::Base
  include Pundit
  include Rails.application.routes.url_helpers

  attr_accessor :page_request_meta_info
  before_action :set_page_request_meta_info
  before_action :set_backend, :initialize_k8_client

  protect_from_forgery with: :exception
  before_action :login_required
  before_action :set_locale

  helper_method :current_user, :desired_language, :page_request_meta_info, :graphna_path, :breadcrumb_list


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

  def json_fail code = 422, message = "", error_code = 0
    render json: {
      message: message,
      error_code: error_code
    }, status: code
  end

  def json_success code = 200, message = ""
    render json: {
      message: message,
    }, status: code
  end

  def desired_language
    (session[:locale] || "en").to_sym == :en ? "中文" : "English"
  end

  def set_locale
    I18n.locale = session[:locale] || :en
  end

  def set_main_content_width
    session[:width] = params[:width]
    puts "width"
    puts session[:width]
    head :ok
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

  #rescue_from ActiveRecord::RecordNotFound, with: :render_404
  #rescue_from Exception, with: :render_404

  def render_404
    flash.notice = t("common.record_not_found")
    redirect_to root_path
  end

  private
  def determine_navbar_item
    case controller_name.to_sym
    when :services, :apps
      :services
    when :nodes, :containers, :images, :networks, :volumes
      :nodes
    when :service_templates
      :service_templates
    when :namespaces
      :namespaces
    when :users, :groups
      :groups
    when :system, :mesos
      :system
    else
      :serivces
    end
  end

  def determine_panel_header_and_icon
    case controller_name.to_sym
    when :services, :apps
      {text: :services, icon: :cogs }
    when :mesos
      {text: :mesos, icon: :cogs }
    when :nodes, :containers, :images, :networks, :volumes
      {text: :nodes, icon: :cogs }
    when :service_templates
      {text: :service_templates, icon: :cogs }
    when :namespaces
      {text: :namespaces, icon: :cogs }
    when :groups, :users
      {text: :account, icon: :users }
    when :system, :mesos, :marathon, :swan
      {text: :system, icon: :cogs }
    else
      {text: :services, icon: :cogs }
    end
  end

  def owner_from_request
    params[:owner_type] == "group" ? current_user.groups.find(params[:owner_id]) : nil
  end

  def audit(entity, action, change = "")
    a = Audit.new
    a.entity = entity
    a.user = current_user
    a.change = change
    a.action = action
    a.save
  end

  def set_backend
    case Site.default.backend_option
    when "swan"
      require 'swan'
      Swan.url = Site.default.swan_addrs
    when "marathon"
      require 'marathon'
      Marathon.options = {:username => Site.default.marathon_username, :password => Site.default.marathon_password}
      Marathon.url = Site.default.marathon_addrs
    when "k8s"
    end
  end

  def graphna_path
    Site.default.graphna_addr + "/dashboard-solo/db/"
    #"https://admin@changem@graphna.hengdingsheng.com" + "/dashboard-solo/db/"
  end

  def breadcrumb_list
    (@breadcrumb_list || []).unshift OpenStruct.new(name_zh_cn: "首页", name_en: "Home", path: root_path)
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def initialize_k8_client
    config = Kubeclient::Config.read('/Users/kevinxu/.kube/config')
    @k8client = Kubeclient::Client.new(
      config.context.api_endpoint,
      config.context.api_version,
      { ssl_options: config.context.ssl_options,
      auth_options: config.context.auth_options }
    )
  end

  private
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

end
