# == Schema Information
#
# Table name: sites
#
#  id                  :integer          not null, primary key
#  docker_public_key   :string
#  mesos_addrs         :text
#  marathon_addrs      :text
#  graphna_addr        :string
#  mesos_state         :string
#  marathon_state      :string
#  graphna_state       :string
#  mesos_last_seen     :datetime
#  marathon_last_seen  :datetime
#  graphna_last_seen   :datetime
#  changelog           :text
#  version             :string
#  feature_flags       :text
#  marathon_username   :string
#  marathon_password   :string
#  backend_option      :string
#  swan_addrs          :string
#  mesos_leader_url    :string
#  marathon_leader_url :string
#  swan_leader_url     :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  registry_domain     :string
#

class Site < ApplicationRecord
  serialize :feature_flags, Array

  def self.default
    if !self.first
      self.create swan_addrs: "http://localhost:9999",
        marathon_addrs: "https://marathon.hengdingsheng.com",
        mesos_addrs: "https://mesos.hengdingsheng.com",
        graphna_addr: "https://graphna.hengdingsheng.com",
        registry_domain: "registry.hengdingsheng.com",
        backend_option: "marathon"
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
