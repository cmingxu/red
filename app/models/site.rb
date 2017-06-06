class Site < ApplicationRecord
  serialize :feature_flags, Array

  def self.default
    if !self.first
      self.create
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
    leader = Mesos.new(leader: "http://114.55.130.152:5050").state['leader']
    self.update_column :mesos_leader_url, "http://" +  leader.split("@")[1] + "/"
  end
end
