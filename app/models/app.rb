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
#

class App < ApplicationRecord
  include AASM
  PROTECTED_ATTRIBUTES = %w(id created_at updated_at raw_config service_id current_version_id backend)

  attr_accessor :labels
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

  validates :name, presence: true
  validates :name, uniqueness: { scope: :service_id }
  before_validation(on: :create) do |app|
    app.instances ||= 0
  end

  aasm :column => :state do
    state :pending, :initial => true
    state :running
    state :done

    event :run do
      transitions :from => [:pending, :stop], :to => :running, after: :deploy
    end

    event :stop do
      transitions :from => :running, :to => :done
    end
  end

  def state_or_backend_state
    self.state
  end

  def deploy
    ap marathon_hash
    begin
      Marathon::App.create marathon_hash
    rescue Marathon::Error::MarathonError => e
      puts e
      puts e.details
    end
  end

  def marathon_hash
    marathon_hash = {
      id: self.name,
      cpus: self.cpu.to_f,
      mem: self.mem,
      instances: self.instances,
      executor: "",
      container: self.container_hash,
      env: self.env,
      labels: self.labels,
      fetch: self.uris.map {|u| { "uri": u }},
      healthChecks: [ self.health_check ]
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
        portMappings: self.portmappings,
      },
      volumes: self.volumes,
    }
  end
end
