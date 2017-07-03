# == Schema Information
#
# Table name: builds
#
#  id           :integer          not null, primary key
#  project_id   :integer
#  serial_num   :integer
#  version_name :string
#  build_status :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Build < ApplicationRecord
  include FriendlyId
  friendly_id :version_name, use: [:slugged, :finders]

  belongs_to :project
  validates :version_name, presence: true


  def login
  end

  def build
    begin
      tmp_dockerfile_path = Rails.root.join("tmp/dockerfiles/#{self.project.namespace.id}/#{self.project.id}/#{self.id}")
      FileUtils.mkdir_p(tmp_dockerfile_path)
      File.write(self.project.dockerfile, tmp_dockerfile_path.join("Dockerfile"))
      Docker::Image.build_from_dir(tmp_dockerfile_path)
    rescue Exception => e
      puts e
    end
  end

  def tag image
    image.tag('repo' => self.project.name, 'tag' => self.version_name, force: true)
  end

  def push
  end
end
