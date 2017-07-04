# == Schema Information
#
# Table name: builds
#
#  id           :integer          not null, primary key
#  project_id   :integer
#  serial_num   :integer
#  version_name :string
#  build_status :string
#  slug         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Build < ApplicationRecord
  include FriendlyId
  friendly_id :version_name, use: [:slugged, :finders]

  belongs_to :project
  validates :version_name, presence: true

  before_validation on: :create do
    self.serial_num = self.project.next_build_serial_num
    self.build_status = "started"
    self.version_name = self.generate_version_name
  end

  def generate_version_name
    if self.project.version_format =~ /{{timestamp}}/
      self.project.version_format.gsub /{{timestamp}}/, Time.now.strftime("%Y%m%d%H%M%S")
    else
      self.project.next_version
    end
  end

  def build_path
    Pathname.new("/tmp/dockerfiles/#{self.project.namespace.id}/#{self.project.id}/#{self.id}")
  end

  def build
    begin
      tmp_dockerfile_path = Pathname.new("/tmp/dockerfiles/#{self.project.namespace.id}/#{self.project.id}/#{self.id}")
      FileUtils.mkdir_p(tmp_dockerfile_path)
      File.write(tmp_dockerfile_path.join("Dockerfile"), self.stripped_dockerfile)
      Docker::Image.build_from_dir(tmp_dockerfile_path.to_s)
      self.update_column :build_status, :built
    rescue Exception => e
      self.update_column :build_status, 'failed'
      self.update_column :exception, e
    end
  end

  def stripped_dockerfile
    self.project.dockerfile.gsub(/{{.*}}/, self.original_filename)
  end

  def tag image
    begin
      image.tag('repo' => self.project.name, 'tag' => self.version_name, force: true)
      self.update_column :build_status, :tagged
    rescue Exception => e
      self.update_column :build_status, 'failed'
      self.update_column :exception, e
    end
  end

  def push
  end
end
