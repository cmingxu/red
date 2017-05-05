# == Schema Information
#
# Table name: apps
#
#  id                 :integer          not null, primary key
#  name               :string
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
  attr_accessor :labels

  belongs_to :service
  belongs_to :user
  belongs_to :group

  serialize :env, Hash
  serialize :health_check, Hash
  serialize :portmappings, Array
  serialize :labels, Array
  serialize :volumes, Array
  serialize :uris, Array
  serialize :gateway, Hash

  PROTECTED_ATTRIBUTES = %w(id created_at updated_at raw_config service_id current_version_id backend)
  validates :name, presence: true
  validates :name, uniqueness: { scope: :service_id }

  before_validation(on: :create) do |app|
    app.instances ||= 0
  end

end
