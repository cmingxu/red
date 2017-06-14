module ServicesHelper
  def app_state_path_helper service, app
    if Site.default.backend_option == "marathon"
      return marathon_app_state_service_app_path service, app
    end

    if Site.default.backend_option == "swan"
      return swan_app_state_service_app_path service, app
    end
  end
end
