# This class represents a Swan Container Volume information.
# See https://mesosphere.github.io/marathon/docs/native-docker.html for full details.
class Swan::ContainerVolume < Swan::Base

  ACCESSORS = %w[ containerPath hostPath mode ]
  DEFAULTS = {
      :mode => 'RW'
  }

  # Create a new container volume object.
  # ++hash++: Hash returned by API.
  def initialize(hash)
    super(Swan::Util.merge_keywordized_hash(DEFAULTS, hash), ACCESSORS)
    Swan::Util.validate_choice('mode', mode, %w[RW RO])
    raise Swan::Error::ArgumentError, 'containerPath must not be nil' unless containerPath
    raise Swan::Error::ArgumentError, 'containerPath must be an absolute path' \
      unless Pathname.new(containerPath).absolute?
    raise Swan::Error::ArgumentError, 'hostPath must not be nil' unless hostPath
  end

  def to_pretty_s
    "#{containerPath}:#{hostPath}:#{mode}"
  end

  def to_s
    "Swan::ContainerVolume { :containerPath => #{containerPath} :hostPath => #{hostPath} :mode => #{mode} }"
  end

end
