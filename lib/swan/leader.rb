# This class represents a Swan Leader.
# See https://mesosphere.github.io/marathon/docs/rest-api.html#get-/v2/leader for full list of API's methods.
class Swan::Leader

  def initialize(marathon_instance = Swan.singleton)
    @connection = marathon_instance.connection
  end

  # Returns the current leader. If no leader exists, raises NotFoundError.
  def get
    json = @connection.get('/v2/leader')
    json['leader']
  end

  # Causes the current leader to abdicate, triggering a new election.
  # If no leader exists, raises NotFoundError.
  def delete
    json = @connection.delete('/v2/leader')
    json['message']
  end

  class << self
    # Returns the current leader. If no leader exists, raises NotFoundError.
    def get
      Swan.singleton.leaders.get
    end

    # Causes the current leader to abdicate, triggering a new election.
    # If no leader exists, raises NotFoundError.
    def delete
      Swan.singleton.leaders.delete
    end
  end
end
