# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  namespace_id   :integer
#  dockerfile     :text
#  user_id        :integer
#  group_id       :integer
#  version_format :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Project < ApplicationRecord
  include FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :namespace
  has_many :builds, dependent: :destroy

  validates :name, presence: true
  validates :dockerfile, presence: true
  validates :version_format, presence: true

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
