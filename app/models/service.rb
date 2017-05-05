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
  attr_accessor :compose

  belongs_to :user
  belongs_to :group
  has_many :apps, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id, if: Proc.new {self.user_id.present?} }
  validates :name, uniqueness: { scope: :group_id, if: Proc.new {self.group_id.present?} }
end
