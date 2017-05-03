# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#

require 'digest'

class User < ApplicationRecord
  ROLE = %w(SITE_ADMIN USER)
  attr_accessor :password

  validates :email, presence: true
  validates :email, uniqueness: true

  has_many :group_users
  has_many :groups, through: :group_users

  has_many :services, dependent: :destroy

  def update_password=(pass)
    self.salt = SecureRandom.hex
    self.encrypted_password = entrypt_password(pass)
  end

  def password_valid?(pass)
    self.encrypted_password == entrypt_password(pass)
  end

  private
  def entrypt_password(pass)
    Digest::MD5.hexdigest self.salt + pass
  end
end
