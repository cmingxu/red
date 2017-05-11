# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string
#  name               :string
#  salt               :string
#  encrypted_password :string
#  icon               :text
#  bio                :text
#  role               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'digest'

class User < ApplicationRecord
  ROLE = %w(SITE_ADMIN ADMIN USER)
  attr_accessor :password, :group_admin

  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users
  has_many :groups_without_default, proc { where("`groups`.id != #{Group.default_group.id}") }, through: :group_users, source: :group
  has_many :admin_groups, proc { where("`group_users`.role > 0 ") }, through: :group_users, source: :group

  has_many :services, dependent: :destroy

  def update_password(pass)
    self.salt = SecureRandom.hex
    self.encrypted_password = entrypt_password(pass)
  end

  def display
    self.name || self.email
  end

  def password_valid?(pass)
    self.encrypted_password == entrypt_password(pass)
  end

  def admin?(group)
    self.admin_groups.include? group
  end

  def join_group!(group, role = :user)
    self.group_users.find_or_create_by(group_id: group.id).send("#{role}!")
  end

  def leave_group!(group, role = :user)
    return false if group.is_default?

    self.group_users(group: group).destroy
  end

  private
  def entrypt_password(pass)
    Digest::MD5.hexdigest self.salt + pass
  end
end
