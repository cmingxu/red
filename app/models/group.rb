# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  desc       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :services

  belongs_to :owner, class_name: "User", foreign_key: :owner_id
end
