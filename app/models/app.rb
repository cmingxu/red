# == Schema Information
#
# Table name: apps
#
#  id                 :integer          not null, primary key
#  name               :string
#  desc               :text
#  backend            :string
#  cpu                :decimal(10, 2)
#  mem                :integer
#  disk               :integer
#  cmd                :string
#  args               :string
#  priority           :integer
#  runas              :string
#  constraints        :string
#  image              :string
#  network            :string
#  portmappings       :text
#  force_image        :boolean
#  privileged         :boolean
#  env                :text
#  volumes            :text
#  uris               :text
#  gateway            :text
#  health_check       :text
#  instances          :integer
#  service_id         :integer
#  current_version_id :integer
#  raw_config         :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  state              :string
#  slug               :string
#  parameters         :text
#  labels             :text
#

class App < ApplicationRecord
  PROTECTED_ATTRIBUTES = %w(id created_at updated_at raw_config service_id current_version_id backend)
  CONFIG_ATTRIBUTES = ["cpu", "mem", "disk", "cmd", "args", "priority", "runas", "constraints", "parameters", "image", "network", "portmappings", "force_image", "privileged", "env", "volumes", "uris", "gateway", "health_check"]
  MARATHON = "marathon"
  SWAN = "swan"

  class Task; attr_accessor :id, :agentId, :ip, :created_at end

  include Auditable
  include AASM
  include FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  before_save do
    self.slug = PinYin.of_string(self.name.gsub(/[-_@\s]/, " ")).join('-').downcase
  end

  attr_accessor :links
  attr_accessor :version_name

  serialize :env, Array
  serialize :health_check, Hash
  serialize :portmappings, Array
  serialize :parameters, Array
  serialize :labels, Array
  serialize :volumes, Array
  serialize :uris, Array
  serialize :constraints, Array
  serialize :gateway, Hash

  belongs_to :service
  belongs_to :user
  belongs_to :group
  has_many :versions, dependent: :destroy
  has_many :app_links, foreign_key: :input_app_id, dependent: :destroy
  has_many :input_app_links, foreign_key: :output_app_id, dependent: :destroy, class_name: "AppLink"
  belongs_to :current_version, class_name: 'Version', foreign_key: :current_version_id

  validates :name, :desc, :cpu, :mem, :disk, :image, presence: true
  validates :name, uniqueness: { scope: :service_id }

  accepts_nested_attributes_for :app_links, allow_destroy: true

  after_create_commit do |app|
    if self.version_name.present?
      v = app.versions.build(name: self.version_name || self.name,
                          raw_config: self.raw_config) if self.version_name.present?
      v.save
      self.version_name = nil
      self.update_column :current_version_id, v.id
    end
  end

  after_update_commit do |app|
    app.versions.create(name: self.version_name || self.name,
                        raw_config: self.raw_config) if self.version_name.present?
    self.version_name = nil
  end

  before_destroy do |app|
    app.stop
  end

  aasm :column => :state do
    state :pending, :initial => true
    state :running
    state :done

    event :backend_run do
      transitions :from => [:pending, :done, :running], :to => :running
    end

    event :backend_stop do
      transitions :from => [:pending, :running, :done], :to => :done
    end
  end

  def state_or_backend_state
    self.state
  end

  before_save do
    self.backend = MARATHON
  end

  delegate :swan_app_name, :swan_app, :scale_up, :scale_down, :marathon_app_name, :run, :stop, :marathon_app, :suspend, :restart, :change, :rollback, :scale, :marathon_hash, :container_hash, :swan_hash, to: :backend_instance

  def cpu_total
    self.instances * self.cpu
  end

  def mem_total
    self.instances * self.mem
  end

  def disk_total
    self.instances * self.disk
  end

  def cpu_used
    self.running? ? self.instances * self.cpu : 0
  end

  def mem_used
    self.running? ? self.instances  * self.mem : 0
  end

  def disk_used
    self.running? ? self.instances * self.disk : 0
  end

  def backend_instance
    case Site.default.backend_option
    when MARATHON
      Backend::Marathon.new self
    when SWAN
      Backend::Swan.new self
    end
  end

  def with_version(version)
    JSON.parse(version.raw_config).slice(*App::CONFIG_ATTRIBUTES).each_pair do |k, v|
      self.send "#{k}=", v
    end

    self
  end

  def set_raw_config(post_raw = "")
    hash = JSON.parse(post_raw)["app"] || {}
    hash.delete("app_links")
    self.raw_config = hash.to_json
  end

  def display locale = :en
    case locale.to_s
    when "en"
      "application #{self.name}"
    when "zh-CN"
      "应用 #{self.name}"
    end
  end

end
