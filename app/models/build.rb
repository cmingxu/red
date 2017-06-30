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
  belongs_to :project
end
