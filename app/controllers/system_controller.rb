class SystemController < ApplicationController
  def index
  end

  def mesos_ping
    Site.default.mesos_ping params[:site][:mesos_addrs]
  end

  def marathon_ping
    Site.default.marathon_ping params[:site][:marathon_addrs]
  end

  def swan_ping
    Site.default.swan_ping params[:site][:swan_addrs]
  end
end
