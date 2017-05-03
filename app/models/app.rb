# == Schema Information
#
# Table name: apps
#
#  id                 :integer          not null, primary key
#  name               :string
#  intances           :integer
#  service_id         :integer
#  current_version_id :integer
#  raw_config         :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class App < ApplicationRecord
  validates :name, presence: true
  validates :instances, presence: true
  validates :name, uniqueness: { scope: :service_id }
  validates :raw_config, presence: true

  belongs_to :services
end
