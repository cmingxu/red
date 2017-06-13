class Mesos
  include HTTParty
  attr_accessor :uri

  def initialize(opts = {})
    opts.symbolize_keys!
    @uri = opts[:leader]
  end


  def state
    self.class.get @uri + "/state.json"
  end

  def endpoint
    self.class.get @uri + "/state.json"
  end

  def health
    self.class.get @uri + "/health"
  end

  def master_health
    self.class.post @uri + "/master/health"
  end

  def api_v1
    self.class.post @uri + "/api/v1"
  end

  def system_stats
    self.class.get @uri + "/system/stats.json"
  end

  def master_api_v1
    self.class.post @uri + "/master/api/v1"
  end

  def maintenance_status
    self.class.get @uri + "/maintenance/status"
  end
end
