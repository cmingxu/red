# This class represents a Swan Task.
# See https://mesosphere.github.io/marathon/docs/rest-api.html#get-/v2/tasks for full list of API's methods.
class Swan::Task < Swan::Base

  ACCESSORS = %w[ id appId host ports servicePorts version stagedAt startedAt ]

  # Create a new task object.
  # ++hash++: Hash including all attributes
  # ++marathon_instance++: SwanInstance holding a connection to marathon
  def initialize(hash, marathon_instance = Swan.singleton)
    super(hash, ACCESSORS)
    @marathon_instance = marathon_instance
  end

  # Kill the task that belongs to an application.
  # ++scale++: Scale the app down (i.e. decrement its instances setting by the number of tasks killed)
  #            after killing the specified tasks.
  def delete!(scale = false)
    new_task = self.class.delete(id, scale)
  end

  alias :kill! :delete!

  def to_s
    "Swan::Task { :id => #{self.id} :appId => #{appId} :host => #{host} }"
  end

  # Returns a string for listing the task.
  def to_pretty_s
    %Q[
Task ID:    #{id}
App ID:     #{appId}
Host:       #{host}
Ports:      #{(ports || []).join(',')}
Staged at:  #{stagedAt}
Started at: #{startedAt}
Version:    #{version}
    ].strip
  end

  class << self

    # List tasks of all applications.
    # ++status++: Return only those tasks whose status matches this parameter.
    #             If not specified, all tasks are returned. Possible values: running, staging.
    def list(status = nil)
      Swan.singleton.tasks.list(status)
    end

    # List all running tasks for application appId.
    # ++appId++: Application's id
    def get(appId)
      Swan.singleton.tasks.get(appId)
    end

  end
end
