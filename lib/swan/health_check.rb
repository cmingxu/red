# This class represents a Swan HealthCheck.
# See https://mesosphere.github.io/marathon/docs/health-checks.html for full details.
class Swan::HealthCheck < Swan::Base

  DEFAULTS = {
      :gracePeriodSeconds => 300,
      :intervalSeconds => 60,
      :maxConsecutiveFailures => 3,
      :path => '/',
      :portIndex => 0,
      :protocol => 'HTTP',
      :timeoutSeconds => 20
  }

  ACCESSORS = %w[ command gracePeriodSeconds intervalSeconds maxConsecutiveFailures
                  path portIndex protocol timeoutSeconds ]

  # Create a new health check object.
  # ++hash++: Hash returned by API.
  def initialize(hash)
    super(Swan::Util.merge_keywordized_hash(DEFAULTS, hash), ACCESSORS)
    Swan::Util.validate_choice(:protocol, protocol, %w[HTTP TCP COMMAND])
  end

  def to_s
    if protocol == 'COMMAND'
      "Swan::HealthCheck { :protocol => #{protocol} :command => #{command} }"
    elsif protocol == 'HTTP'
      "Swan::HealthCheck { :protocol => #{protocol} :portIndex => #{portIndex} :path => #{path} }"
    else
      "Swan::HealthCheck { :protocol => #{protocol} :portIndex => #{portIndex} }"
    end
  end

end
