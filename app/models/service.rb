# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  name       :string
#  desc       :string
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Service < ApplicationRecord
  include Accessible

  attr_accessor :compose, :compose_content

  belongs_to :user
  belongs_to :group
  has_many :apps, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id, if: Proc.new {self.user_id.present?} }
  validates :name, uniqueness: { scope: :group_id, if: Proc.new {self.group_id.present?} }

  def raw_config(request_app_version_map = {})
    service_config_hash = {
      name: self.name,
      desc: self.desc
    }

    config_apps = {}
    request_app_version_map.each_pair do |k, v|
      app = self.apps.find k
      version = app.versions.find v

      config_apps[app.name] = JSON.parse(version.raw_config)
    end

    service_config_hash['apps'] = config_apps
    service_config_hash
  end

  def owner
    if self.user_id
      return User.find self.user_id
    end

    if self.group_id
      return Group.find self.group_id
    end

    return nil
  end

  def toggle_favorite!
    self.favorite = !self.favorite
    self.save
  end

  def from_raw_config(compose_hash)
    compose_hash["apps"].each_pair do |app_name, raw_config|
      app = self.apps.build raw_config
      app.raw_config = raw_config.to_json
      app.version_name = app.name
    end

    self
  end

  %w(cpu_total cpu_used mem_total mem_used disk_total disk_used).each do |m|
    define_method m do
      self.apps.reduce(0){|sum, app| sum += app.send(m); sum }
    end
  end

end
