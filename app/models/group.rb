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

  def add_user!(user, role = :user)
    gu = self.group_users.find_or_create_by(user_id: user.id)
    if gu.role && (gu.role < GroupUser.role[role])
      return true
    end

    gu.send("#{role}!")
  end

  def self.default_group
    Group.first
  end

  def is_default?
    Group.default_group == self
  end

end
