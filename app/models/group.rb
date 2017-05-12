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
  belongs_to :owner, class_name: "User", foreign_key: :owner_id
  has_many :group_users, dependent: :destroy
  has_many :users, through: :group_users
  has_many :admin_users, proc { where("`group_users`.role = #{GroupUser.roles[:admin]}") }, through: :group_users, source: :user
  has_many :site_admins, proc { where("`group_users`.role = #{GroupUser.roles[:site_admin]}") }, through: :group_users, source: :user
  has_many :services

  validates :name, presence: true
  validates :name, uniqueness: true

  mount_uploader :icon, GroupIconUploader

  has_settings do |s|
    # mem 10G, disk 1024G
    s.key :quota, :defaults => { :cpu => 20, :mem => 10 * 1028 , :disk => 1024  }
  end

  def add_user!(user, role = :user)
    gu = self.group_users.find_or_create_by(user_id: user.id)
    if gu.role && (GroupUser.roles[role] > GroupUser.roles[gu.role] )
      return true
    end

    gu.send("#{role}!")
  end

  def conditional_services
    self.is_default? ? Service.all : self.services
  end

  def self.default_group
    Group.first
  end

  def is_default?
    Group.default_group == self
  end

  %w(cpu_total cpu_used mem_total mem_used disk_total disk_used).each do |m|
    define_method m do
      self.conditional_services.reduce(0){|sum, s| sum += s.send(m); sum }
    end
  end

end
