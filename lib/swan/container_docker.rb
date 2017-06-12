# This class represents a Swan Container docker information.
# See https://mesosphere.github.io/marathon/docs/native-docker.html for full details.
class Swan::ContainerDocker < Swan::Base

  ACCESSORS = %w[ image network privileged parameters ]
  DEFAULTS = {
      :network => 'BRIDGE',
      :portMappings => []
  }

  attr_reader :portMappings

  # Create a new container docker object.
  # ++hash++: Hash returned by API.
  def initialize(hash)
    super(Swan::Util.merge_keywordized_hash(DEFAULTS, hash), ACCESSORS)
    Swan::Util.validate_choice('network', network, %w[BRIDGE HOST])
    Swan::Util.validate_choice('privileged', privileged, ['true', 'false', true, false])
    raise Swan::Error::ArgumentError, 'image must not be nil' unless image
    @portMappings = (info[:portMappings] || []).map { |e| Swan::ContainerDockerPortMapping.new(e) }
  end

  def to_pretty_s
    "#{image}"
  end

  def to_s
    "Swan::ContainerDocker { :image => #{image} }"
  end

end
