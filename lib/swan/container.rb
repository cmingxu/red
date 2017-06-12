# This class represents a Swan Container information.
# It is included in App's definition.
# See https://mesosphere.github.io/marathon/docs/native-docker.html for full details.
class Swan::Container < Swan::Base

  SUPPERTED_TYPES = %w[ DOCKER MESOS]
  ACCESSORS = %w[ type ]
  DEFAULTS = {
      :type => 'DOCKER',
      :volumes => []
  }

  attr_reader :docker, :volumes

  # Create a new container object.
  # ++hash++: Hash returned by API.
  def initialize(hash)
    super(Swan::Util.merge_keywordized_hash(DEFAULTS, hash), ACCESSORS)
    Swan::Util.validate_choice('type', type, SUPPERTED_TYPES)
    @docker = Swan::ContainerDocker.new(info[:docker]) if info[:docker]
    @volumes = info[:volumes].map { |e| Swan::ContainerVolume.new(e) }
  end

  def to_s
    "Swan::Container { :type => #{type} :docker => #{Swan::Util.items_to_pretty_s(docker)}"\
    + " :volumes => #{Swan::Util.items_to_pretty_s(volumes)} }"
  end

end
