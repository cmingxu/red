require 'rubygems/package'
require 'httparty'
require 'json'
require 'uri'
require 'timeout'

# The top-level module for this gem. It's purpose is to hold global
# configuration variables that are used as defaults in other classes.
module Swan

  attr_accessor :logger

  require 'swan/version'
  require 'swan/util'
  require 'swan/error'
  require 'swan/connection'
  require 'swan/base'
  require 'swan/constraint'
  require 'swan/container_docker_port_mapping'
  require 'swan/container_docker'
  require 'swan/container_volume'
  require 'swan/container'
  require 'swan/health_check'
  require 'swan/task'
  require 'swan/app'
  require 'swan/leader'

  # Represents an instance of swan
  class SwanInstance
    attr_reader :connection

    def initialize(url, options)
      @connection = Connection.new(url, options)
    end

    def ping
      connection.get('/ping')
    end

    # Get information about the swan server
    def version
      connection.get('/version')
    end

    def metrics
      connection.get('/metrics')
    end

    def stats
      connection.get('/stats')
    end

    def apps
      Swan::Apps.new(self)
    end

    def leaders
      Swan::Leader.new(self)
    end

  end


  DEFAULT_URL = 'http://localhost:5013'

  attr_reader :singleton

  @singleton = SwanInstance::new(DEFAULT_URL, {})

  # Get the swan url from environment
  def env_url
    ENV['SWAN_URL']
  end

  # Get swan options from environment
  def env_options
    opts = {}
    opts
  end

  # Get the swan API URL
  def url
    @url ||= env_url || DEFAULT_URL
    @url
  end

  # Get options for connecting to swan API
  def options
    @options ||= env_options
  end

  # Set a new url
  def url=(new_url)
    @url = new_url
    reset_singleton!
  end

  # Set new options
  def options=(new_options)
    @options = env_options.merge(new_options || {})
    reset_singleton!
  end

  # Set a new connection
  def connection
    singleton.connection
  end


  def reset_singleton!
    @singleton = SwanInstance.new(url, options)
  end

  def reset_connection!
    reset_singleton!
  end

  # Get information about the swan server
  def stats
    singleton.stats
  end

  def version
    singleton.version
  end

  # Ping swan
  def ping
    singleton.ping
  end

  def metrics
    singleton.metrics
  end

  module_function :connection, :env_options, :env_url, :stats, :logger, :logger=, :ping, :metrics, :version,
                  :options, :options=, :url, :url=, :reset_connection!, :reset_singleton!, :singleton
end
