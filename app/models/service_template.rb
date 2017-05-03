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
  validates :name, presence: true
  validates :icon, presence: true
  validates :readme, presence: true
  validates :desc, presence: true

  belongs_to :user
  belongs_to :group
end
