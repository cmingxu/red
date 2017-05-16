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
#

class App < ApplicationRecord
  PROTECTED_ATTRIBUTES = %w(id created_at updated_at raw_config service_id current_version_id backend)

  class Task; attr_accessor :id, :agentId, :ip, :created_at end

  include Auditable
  include AASM

  attr_accessor :labels
  attr_accessor :version_name

  serialize :env, Hash
  serialize :health_check, Hash
  serialize :portmappings, Array
  serialize :labels, Array
  serialize :volumes, Array
  serialize :uris, Array
  serialize :gateway, Hash

  belongs_to :service
  belongs_to :user
  belongs_to :group
  has_many :versions, dependent: :destroy
  belongs_to :current_version, class_name: 'Version', foreign_key: :current_version_id

  validates :name, presence: true
  validates :name, uniqueness: { scope: :service_id }

  before_validation(on: :create) do |app|
    app.instances ||= 0
  end

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
      transitions :from => [:pending, :done], :to => :running
    end

    event :backend_stop do
      transitions :from => [:pending, :running], :to => :done
    end
  end

  def state_or_backend_state
    self.state
  end

  def run(version = nil)
    version ||= self.versions.last
    begin
      Marathon::App.create self.with_version(version).marathon_hash.merge!("instances": 0)
      (self.current_version = version) && self.save
      self.backend_run!
    rescue Marathon::Error::MarathonError => e
      puts e
      puts e.details
    rescue Marathon::Error::UnexpectedResponseError => e
      puts e
      puts e.details
    end
  end

  def stop
    begin
      Marathon::App.delete self.marathon_app_name
      self.backend_stop!
    rescue Marathon::Error::NotFoundError => e
      Rails.logger.debug e
    end

    if self.service.apps.running.present?
      begin
        Marathon::Group.delete self.service.name
      rescue Marathon::Error::NotFoundError => e
        Rails.logger.debug e
      end
    end

  end

  def suspend
    marathon_app.suspend!
  end

  def restart
    marathon_app.restart!
  end

  def change(version)
    version ||= self.versions.last
    begin
      self.marathon_app.change! self.with_version(version).marathon_hash
      self.current_version = version
    rescue Marathon::Error::MarathonError => e
      puts e
      puts e.details
    rescue Marathon::Error::UnexpectedResponseError => e
      puts e
      puts e.details
    else
      self.save
    end
  end

  def rollback(version)
    marathon_app.roll_back! version
  end

  def scale(ins = 1)
    begin
      marathon_app.scale! ins
    rescue Marathon::Error::MarathonError => e
      puts e
      puts e.details
    rescue Marathon::Error::UnexpectedResponseError => e
      puts e
      puts e.details
    end
  end

  def cpu_used
    0
    #self.running? ? self.instances * self.cpu : 0
  end


  def mem_used
    #self.running? ? self.instances  * self.mem : 0
    0
  end

  def disk_used
    #self.running? ? self.instances * self.dise : 0
    0
  end


  def marathon_app_name
    self.service.name + "/" + self.name
  end

  def marathon_app
    begin
      Marathon::App.get self.marathon_app_name
    rescue Marathon::Error::NotFoundError => e
    end
  end

  def with_version(version)
    self.attributes = JSON.parse(version.raw_config)
    self.version_name = nil
    self
  end

  def marathon_hash
    marathon_hash = {
      id: self.marathon_app_name,
      cpus: self.cpu.to_f,
      mem: self.mem,
      instances: self.instances,
      #executor: "",
      container: self.container_hash,
      env: self.env,
      labels: self.labels,
      #fetch: self.uris.map {|u| { "uri": u }},
      healthChecks: [ ]
    }

    if self.cmd.present?
      marathon_hash[:cmd] = self.cmd
    end

    marathon_hash
  end

  def container_hash
    {
      type: "DOCKER",
      docker: {
      image: self.image,
      network: self.network.upcase,
      privileged: self.privileged,
      #portMappings: self.portmappings,
    },
    volumes: self.volumes,
    }
  end
end
