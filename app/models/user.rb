# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :group_users
  has_many :groups, through: :group_users

  has_many :services, dependent: :destroy
end
