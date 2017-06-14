class Site < ApplicationRecord
  serialize :feature_flags, Array

  def self.default
    if !self.first
      self.create swan_addrs: "http://localhost:9999",
        marathon_addrs: "http://localhost:8080",
        mesos_addrs: "localhost:5050"

    end

    self.first
  end

  def self.seen_component(component, at = Time.now)
    Site.default.update_column "#{component}_last_seen=", at
  end

  def fetch_and_set_marathon_leader
    self.update_column :marathon_leader_url, "http://" +  Marathon.info['leader'] + "/"
  end

  def fetch_and_set_mesos_leader
    leader = Mesos.new(leader: self.mesos_addrs).state['leader']
    self.update_column :mesos_leader_url, "http://" +  leader.split("@")[1] + "/"
  end

  def fetch_and_set_swan_leader
  end

  def mesos_ping(mesos_addrs)
    begin
      { result: Mesos.new(leader: mesos_addrs).master_health.response.is_a?(Net::HTTPOK), message: "" }
    rescue Exception => e
      { result: false, message: e.message }
    end
  end

  def marathon_ping marathon_addrs, marathon_username, marathon_password
    begin
      require 'marathon'
      Marathon.options = {:username => marathon_username, :password => marathon_password}
      Marathon.url = marathon_addrs
      Marathon.ping == "pong"
    rescue JSON::ParserError => e
      { result: true, message:  e.message }
    rescue Exception => e
      { result: false, message:  e.message }
    end
  end

  def swan_ping swan_addrs
    begin
      require 'swan'
      Swan.url = swan_addrs
      { result: Swan.ping == "pong", message: ""}
    rescue Exception => e
      { result: false, message:  e.message }
    end
  end
end
