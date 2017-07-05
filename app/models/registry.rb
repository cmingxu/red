class Registry
  attr_accessor :name

  def self.default
    Registry.new
  end
end
