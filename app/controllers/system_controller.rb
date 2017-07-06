class SystemController < ApplicationController
  def index
  end

  def info
  end

  def update_mesos_config
    ret = Site.default.mesos_ping params[:site][:mesos_addrs]
    if ret[:result]
      Site.default.update_attributes mesos_addrs: params[:site][:mesos_addrs]
      Site.default.fetch_and_set_mesos_leader
      render js: "$.notify('success, mesos leader found at #{Site.default.mesos_leader_url}')"
    else
      render js: "$.notify('#{ret[:message].escape_malformed}')"
    end
  end

  def update_domain_config
    Site.default.update_attributes domain: params[:site][:domain]
    render js: "$.notify('domain update successfully')"
  end

  def update_registry_domain_config
    Site.default.update_attributes registry_domain: params[:site][:registry_domain]
    render js: "$.notify('registry_domain update successfully')"
  end

  def update_marathon_config
    ret = Site.default.marathon_ping(params[:site][:marathon_addrs],
                                     params[:site][:marathon_username],
                                     params[:site][:marathon_password])

    if ret[:result]
      Site.default.update_attributes marathon_addrs: params[:site][:marathon_addrs],
        marathon_username: params[:site][:marathon_username],
        marathon_password: params[:site][:marathon_password]

      Site.default.fetch_and_set_marathon_leader
      render js: "$.notify('success, marathon leader found at #{Site.default.marathon_leader_url}')"
    else
      render js: "$.notify(\"#{ret[:message].escape_malformed}\")"
    end
  end

  def update_swan_config
    ret = Site.default.swan_ping params[:site][:swan_addrs]
    if ret[:result]
      Site.default.update_attributes swan_addrs: params[:site][:swan_addrs]
      Site.default.fetch_and_set_swan_leader
      render js: "$.notify('success, swan leader found at #{Site.default.swan_leader_url}')"
    else
      render js: "$.notify('#{ret[:message].escape_malformed}')"
    end
  end

  def update_graphna_config
    Site.default.update_attributes graphna_addr: params[:site][:graphna_addr]
    render js: "$.notify('success')"
  end
end
