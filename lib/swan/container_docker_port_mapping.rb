# This class represents a Swan Container docker information.
# See https://mesosphere.github.io/marathon/docs/native-docker.html for full details.
class Swan::ContainerDockerPortMapping < Swan::Base

  ACCESSORS = %w[ containerPort hostPort servicePort protocol ]
  DEFAULTS = {
      :protocol => 'tcp',
      :hostPort => 0
  }

  # Create a new container docker port mappint object.
  # ++hash++: Hash returned by API.
  def initialize(hash)
    super(Swan::Util.merge_keywordized_hash(DEFAULTS, hash), ACCESSORS)
    Swan::Util.validate_choice('protocol', protocol, %w[tcp udp])
    raise Swan::Error::ArgumentError, 'containerPort must not be nil' unless containerPort
    raise Swan::Error::ArgumentError, 'containerPort must be a non negative number' \
      unless containerPort.is_a?(Integer) and containerPort >= 0
    raise Swan::Error::ArgumentError, 'hostPort must be a non negative number' \
      unless hostPort.is_a?(Integer) and hostPort >= 0
  end

  def to_pretty_s
    "#{protocol}/#{containerPort}:#{hostPort}"
  end

  def to_s
    "Swan::ContainerDockerPortMapping { :protocol => #{protocol} " \
    + ":containerPort => #{containerPort} :hostPort => #{hostPort} }"
  end

end
