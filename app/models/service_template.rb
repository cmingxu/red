# == Schema Information
#
# Table name: service_templates
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
#  group_id   :integer
#  user_id    :integer
#  raw_config :text
#  desc       :string
#  readme     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ServiceTemplate < ApplicationRecord
  include Accessible
  include FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
  before_save do
    self.slug = PinYin.of_string(self.name).join('-').downcase
  end

  mount_uploader :icon, ServiceTemplateIconUploader

  validates :name, presence: true
  validates :readme, presence: true
  validates :desc, presence: true
  validates :raw_config, presence: true

  belongs_to :user
  belongs_to :group

  def owner
    if self.user_id
      return User.find self.user_id
    end

    if self.group_id
      return Group.find self.group_id
    end

    return nil
  end

  def display locale = :en
    case locale.to_s
    when "en"
      "service template #{self.name}"
    when "zh-CN"
      "应用模板 #{self.name}"
    end
  end
end
