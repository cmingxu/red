class Mesos
  include HTTParty
  attr_accessor :uri
  def initialize(opts = {})
    opts.symbolize_keys!
    ap opts
    @uri = opts[:leader]
  end


  def state
    self.class.get @uri + "/state.json"
  end
end
