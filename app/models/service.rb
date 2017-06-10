# == Schema Information
#
# Table name: services
#
#  id         :integer          not null, primary key
#  name       :string
#  desc       :string
#  favorite   :boolean
#  group_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Service < ApplicationRecord
  include Accessible
  include Auditable
  include FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  before_save do
    self.slug = PinYin.of_string(self.name.gsub(/[-_@\s]/, " ")).join('-').downcase
  end

  attr_accessor :compose, :compose_content

  belongs_to :user
  belongs_to :group
  has_many :apps, dependent: :destroy
  has_many :app_links, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id, if: Proc.new {self.user_id.present?} }
  validates :name, uniqueness: { scope: :group_id, if: Proc.new {self.group_id.present?} }

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
    service_config_hash["apps"] = config_apps

    config_links = []
    self.app_links.each do |link|
      config_links <<  {input_app_name: link.input_app.name, alias: link.alias, output_app_name: link.output_app.name }
    end
    service_config_hash["links"] = config_links

    service_config_hash
  end

  def from_raw_config(compose_hash)
    compose_hash["apps"].each_pair do |app_name, raw_config|
      app = self.apps.build raw_config
      app.raw_config = raw_config.to_json
      app.version_name = app.name
    end

    compose_hash["links"].each do |link|
      input_app = self.apps.select{ |app| app.name ==  link['input_app_name'] }.first
      output_app = self.apps.select{ |app| app.name ==  link['output_app_name'] }.first
      if input_app && output_app
        input_app.app_links.build output_app: output_app, alias: link['alias'], service: self
      end
    end

    self
  end

  def graph_json
    operators = {}
    top = 20
    left = 200

    self.apps.each do |app|
      config =  {
        top: top ,
        left: left,
        properties: { title: app.name,
                      inputs: {},
                      outputs: {}
      }
      }

      app.input_app_links.each_with_index do |link, index|
        config[:properties][:inputs]["input_#{index + 1}"] = {
          #label: "Input #{index + 1}"
          label: ""
        }
      end

      app.app_links.each_with_index do |link, index|
        config[:properties][:outputs]["output_#{index + 1}"] = {
          #label: "Output #{index + 1}"
          label: ""
        }
      end


      operators[app.name] =  config
      top += 60
      left += 100
    end

    links = {}
    self.app_links.each_with_index do |link, index|
      links["link_#{index+1}"] = {
        fromOperator: link.input_app.name,
        fromConnector: "output_#{link.input_app.app_links.index(link) + 1}",
        toOperator: link.output_app.name,
        toConnector: "input_#{link.output_app.input_app_links.index(link) + 1}"
      }
    end

    {operators: operators, links: links}.to_json
  end

  %w(cpu_total cpu_used mem_total mem_used disk_total disk_used).each do |m|
    define_method m do
      self.apps.reduce(0){|sum, app| sum += app.send(m); sum }
    end
  end

  def display locale = :en
    case locale.to_s
    when "en"
      "service #{self.name}"
    when "zh-CN"
      "服务 #{self.name}"
    end
  end

end
