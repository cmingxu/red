# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  name           :string
#  namespace_id   :integer
#  dockerfile     :text
#  user_id        :integer
#  group_id       :integer
#  version_format :string
#  slug           :string
#  token          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Project < ApplicationRecord
  include FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :namespace
  has_many :builds, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :namespace_id }
  validates :dockerfile, presence: true
  validates :version_format, presence: true

  before_validation do
    self.dockerfile = self.dockerfile.gsub("\r\n", "\n")
  end

  before_validation on: :create do
    self.token = SecureRandom.hex(32)
  end

  def file_var
    self.dockerfile =~ /{{(.*)}}/
    $1
  end

  def next_build_serial_num
    "%06d" % self.builds.count
  end

  def next_version
    (self.builds.last.try(:version_name) || "000001").succ
  end

  def owner
    if self.user_id
      return User.find self.user_id
    end

    if self.group_id
      return Group.find self.group_id
    end

    return nil
  end
end
