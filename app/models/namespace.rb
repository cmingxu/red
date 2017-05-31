# == Schema Information
#
# Table name: namespaces
#
#  id         :integer          not null, primary key
#  name       :string
#  user_id    :integer
#  group_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Namespace < ApplicationRecord
  include Accessible
  include FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :repositories, dependent: :destroy
  belongs_to :user
  belongs_to :group

  validates :name, uniqueness: true
  validates :name, presence: true
  NAME_REGEXP = /\A[a-z0-9]+(?:[._\\-][a-z0-9]+)*\Z/
  validates :name, format: { with: NAME_REGEXP, message: NAME_REGEXP }

  def self.from_notifications(events)
    events.each do |event|
      handle_push_event(event) if event['action'] == 'push'
      handle_pull_event(event) if event['action'] == 'pull'
    end
  end

  def self.handle_push_event(event)
    return if event['target']['mediaType'] != 'application/vnd.docker.distribution.manifest.v2+json'
    return if event['target']['repository'].split("/").length != 2

    namespace_name, image_name = event['target']['repository'].split("/")

    namespace = self.find_by(name: namespace_name)
    return if namespace.nil?

    repository = namespace.repositories.find_or_create_by(name: event['target']['repository'])
    repository.latest_tag_name = event['target']['tag']
    repository.save

    repo_tag = repository.repo_tags.find_or_initialize_by(name: event['target']['tag'])
    repo_tag.namespace = namespace
    repo_tag.blob_size = event['target']['length']
    repo_tag.digest = event['target']['digest']
    repo_tag.url = event['target']['url']
    repo_tag.source = event['source']['addr']
    repo_tag.user = User.where(email: event['actor']['name']).first
    repo_tag.owner_name = event['actor']['name']
    repo_tag.save
  end

  def self.handle_pull_event(event)
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

  def display locale = :en
    case locale.to_s
    when "en"
      "namespace #{self.name}"
    when "zh-CN"
      "项目 #{self.name}"
    end
  end
end
